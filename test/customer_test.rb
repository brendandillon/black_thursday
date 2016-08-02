require './test/test_helper'
require './lib/sales_engine'

class CustomerTest < Minitest::Test

  def test_that_it_has_an_id
    customer = Customer.new({ id: 12, first_name: "Claude", last_name: "Montgomery", created_at: "2016-07-26 02:23:16 UTC", updated_at: "1970-04-01 12:45:13 UTC" })

    assert_equal 12, customer.id
  end

  def test_that_it_has_a_first_name
    customer = Customer.new({ id: 12, first_name: "Claude", last_name: "Montgomery", created_at: "2016-07-26 02:23:16 UTC", updated_at: "1970-04-01 12:45:13 UTC" })

    assert_equal "Claude", customer.first_name
  end

  def test_that_it_has_a_last_name
    customer = Customer.new({ id: 12, first_name: "Claude", last_name: "Montgomery", created_at: "2016-07-26 02:23:16 UTC", updated_at: "1970-04-01 12:45:13 UTC" })

    assert_equal "Montgomery", customer.last_name
  end

  def test_that_it_finds_when_created
    customer = Customer.new({ id: 12, first_name: "Claude", last_name: "Montgomery", created_at: "2016-07-26 02:23:16 UTC", updated_at: "1970-04-01 12:45:13 UTC" })

    assert_equal Time.new(2016, 07, 26, 02, 23, 16, "-00:00"), customer.created_at
  end

  def test_that_it_finds_when_updated
    customer = Customer.new({ id: 12, first_name: "Claude", last_name: "Montgomery", created_at: "2016-07-26 02:23:16 UTC", updated_at: "1970-04-01 12:45:13 UTC" })

    assert_equal Time.new(1970, 04, 01, 12, 45, 13, "-00:00"), customer.updated_at
  end

  def test_that_a_customer_points_to_its_merchants
    se = SalesEngine.from_csv({ merchants: "./test/samples/merchants_sample.csv", customers: "./test/samples/customers_sample.csv", invoices: "./test/samples/invoices_sample.csv" })
    customer = se.customers.find_by_id(14)

    assert_equal true, customer.merchants.is_a?(Array)
    assert_equal 2, customer.merchants.length
    assert_equal "Shopin1901", customer.merchants[0].name
  end

  def test_that_a_customer_points_to_its_invoices
    se = SalesEngine.from_csv({ customers: "./test/better_samples/customers.csv", invoices: "./test/better_samples/invoices.csv", transactions: "./test/better_samples/transactions.csv" })
    customer = se.customers.find_by_id(1)

    assert_equal true, customer.invoices.is_a?(Array)
    assert_equal 8, customer.invoices.length
    assert_equal 1, customer.invoices[0].id
  end

  def test_that_a_customer_points_to_its_fully_paid_invoices
    se = SalesEngine.from_csv({ customers: "./test/better_samples/customers.csv", invoices: "./test/better_samples/invoices.csv", transactions: "./test/better_samples/transactions.csv" })
    customer = se.customers.find_by_id(1)

    assert_equal true, customer.fully_paid_invoices.is_a?(Array)
    assert_equal 6, customer.fully_paid_invoices.length
    assert_equal 1, customer.fully_paid_invoices[0].id
  end

  def test_a_customer_knows_how_many_items_it_has_purchased
    se = SalesEngine.from_csv({ customers: "./test/better_samples/customers.csv", invoices: "./test/better_samples/invoices.csv", invoice_items: "./test/better_samples/invoice_items.csv", merchants: "./test/better_samples/merchants.csv" })
    customer = se.customers.find_by_id(3)

    assert_equal 109, customer.items_per_merchant.values.reduce(:+)
  end

  def test_that_it_can_find_total_items_purchases_per_merchant
    se = SalesEngine.from_csv({ customers: "./test/better_samples/customers.csv", invoices: "./test/better_samples/invoices.csv", invoice_items: "./test/better_samples/invoice_items.csv", merchants: "./test/better_samples/merchants.csv" })
    customer = se.customers.find_by_id(3)

    assert_equal 29, customer.items_per_merchant.values[0]
    assert_equal 41, customer.items_per_merchant.values[1]
    assert_equal 39, customer.items_per_merchant.values[2]
  end

  def test_it_knows_which_items_it_purchased
    se = SalesEngine.from_csv({ customers: "./test/better_samples/customers.csv", invoices: "./test/better_samples/invoices.csv", invoice_items: "./test/better_samples/invoice_items.csv", merchants: "./test/better_samples/merchants.csv", items: "./test/better_samples/items.csv" })
    customer = se.customers.find_by_id(3)

    assert_equal Item, customer.items[0].class
    assert_equal true, customer.items.is_a?(Array)
  end

  def test_a_customer_points_to_its_invoice_items
    se = SalesEngine.from_csv({ customers: "./test/better_samples/customers.csv", invoices: "./test/better_samples/invoices.csv", invoice_items: "./test/better_samples/invoice_items.csv", merchants: "./test/better_samples/merchants.csv", items: "./test/better_samples/items.csv" })
    customer = se.customers.find_by_id(3)

    assert_equal InvoiceItem, customer.invoice_items[0].class
    assert_equal true, customer.invoice_items.is_a?(Array)
  end

end
