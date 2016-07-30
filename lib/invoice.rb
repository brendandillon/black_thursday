require 'pry'
class Invoice

  attr_reader :id,
              :customer_id,
              :merchant_id,
              :status,
              :created_at,
              :updated_at,
              :parent_repo

  def initialize(datum, parent_repo = nil)
    @id = datum[:id].to_i
    @customer_id = datum[:customer_id].to_i
    @merchant_id = datum[:merchant_id].to_i
    @status = datum[:status].to_s.to_sym
    @created_at = Time.parse(datum[:created_at])
    @updated_at = Time.parse(datum[:updated_at])
    @parent_repo = parent_repo
  end

  def merchant
    parent_repo.find_merchant(merchant_id)
  end

  def transactions
    parent_repo.find_transactions(id)
  end

  def customer
    parent_repo.find_customer(customer_id)
  end

  def items
    parent_repo.find_invoice_items(id) do |invoice_items|
      return invoice_items.map do |invoice_item|
        invoice_item.item
      end.compact.uniq
    end
  end

  def invoice_items
    parent_repo.find_invoice_items(id)
  end

  def check_results(transactions)
    transactions.find_all do |transaction|
      transaction.result == "success"
    end
  end

  def is_paid_in_full?
    check_results(transactions).length > 0
  end

  def total
    invoice_items.reduce(0) do |amount, invoice_item|
      amount += (invoice_item.quantity * invoice_item.unit_price)
      amount
    end
  end



end
