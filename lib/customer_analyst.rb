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
    # customer.invoices.reduce(0) do |amount, invoice|
    #   amount += invoice.total
    #   amount
    # end
  end

end
