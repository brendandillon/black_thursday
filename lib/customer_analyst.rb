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

  def one_time_buyers_items
    # otb_items = one_time_buyers[0].items
    # one_time_buyers.each do |buyer|
    #   otb_items.delete_if do |item|
    #     buyer.items.include?(item)
    #   end
    # end
    # return otb_items

    all_items = one_time_buyers.map do |buyer|
      # buyer.invoices.map do |invoice|
      #   invoice.invoice_items
      # end
      buyer.items
    end.flatten

    # items_per_count = all_items.reduce(Hash.new {0}) do |items_by_count, invoice_item|
    #   items_by_count[invoice_item.item] += invoice_item.quantity
    #   items_by_count
    items_per_count = all_items.reduce(Hash.new {0}) do |items_by_count, item|
      items_by_count[item] += 1
      items_by_count
    end

    items_per_count.group_by do |item, count|
      count
    end.max
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

  def customers_with_unpaid_invoices
    @all_customers.find_all do |customer|
      customer.invoices != customer.fully_paid_invoices
    end
  end


end
