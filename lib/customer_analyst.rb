class CustomerAnalyst
  attr_reader :all_customers

  def initialize(all_customers)
    @all_customers = all_customers
  end

  def top_buyers(num_to_show = 20)
    all_customers.max_by(num_to_show) do |customer|
      total_for_customer(customer)
    end
  end

  def total_for_customer(customer)
    return 0 if customer.fully_paid_invoices == []
    customer.fully_paid_invoices.map do |invoice|
      invoice.total
    end.uniq.reduce(:+)
  end

  def find_customer(id_to_find)
    @all_customers.find do |customer|
      customer.id == id_to_find
    end
  end

  def top_merchant_for_customer(customer_id)
    customer = find_customer(customer_id)
    customer.items_per_merchant.max_by { |key, value| value}[0]
  end

  def one_time_buyers
    @all_customers.find_all do |customer|
      customer.fully_paid_invoices.length == 1
    end
  end

  def all_one_time_buyers_items
    one_time_buyers.map do |buyer|
      buyer.items
    end.flatten
  end

  def one_time_buyers_item_count(items)
    items.reduce(Hash.new {0}) do |item_count, item|
      item_count[item] += 1
      item_count
    end
  end

  def one_time_buyers_group_by_count(items_per_count)
    items_per_count.reduce(Hash.new) do |group, (item, count)|
      if group[count] == nil
        group[count] = [item]
      else
      group[count] << item
    end
      group
    end
  end

  def one_time_buyers_items
    one_time_buyers_group_by_count(one_time_buyers_item_count(all_one_time_buyers_items)).max[1]
  end

  def items_bought_in_year(customer_id, year)
    customer = find_customer(customer_id)
    invoices_in_year(year, customer).map do |invoice|
      invoice.items
    end.flatten
  end

  def invoices_in_year(year, customer)
    customer.fully_paid_invoices.find_all do |invoice|
      invoice.created_at.year == year
    end
  end

  def most_recent_invoices(customer)
    customer.fully_paid_invoices.reduce(Array.new) do |recent_invoices, invoice|
      if recent_invoices == []
        recent_invoices << invoice
      elsif invoice.updated_at > recent_invoices[0].updated_at
        recent_invoices = [invoice]
      elsif invoice.updated_at == recent_invoices[0].updated_at
        recent_invoices << invoice
      end
      recent_invoices
    end
  end

  def most_recently_bought_items(customer_id)
    customer = find_customer(customer_id)
    most_recent_invoices(customer).map do |invoice|
      invoice.items
    end.flatten
  end


  def customers_with_unpaid_invoices
    @all_customers.find_all do |customer|
      customer.invoices != customer.fully_paid_invoices
    end
  end


end
