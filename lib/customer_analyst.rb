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
    return 0 if customer.invoices == []
    customer.invoices.map do |invoice|
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
    customer.items_for_customer.max_by { |key, value| value}[0].name
  end


end
