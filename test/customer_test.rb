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
    se = SalesEngine.from_csv({ customers: "./test/samples/customers_sample.csv", invoices: "./test/samples/invoices_sample.csv" })
    customer = se.customers.find_by_id(14)

    assert_equal true, customer.invoices.is_a?(Array)
    assert_equal 5, customer.invoices.length
    assert_equal 74, customer.invoices[0].id
  end

  def test_a_customer_knows_how_many_items_it_has_purchased
    se = SalesEngine.from_csv({ customers: "./test/better_samples/customers.csv", invoices: "./test/better_samples/invoices.csv", invoice_items: "./test/better_samples/invoice_items.csv", merchants: "./test/better_samples/merchants.csv" })
    customer = se.customers.find_by_id(3)

    assert_equal 109, customer.items_for_customer.values.reduce(:+)
  end

  def test_that_it_can_find_total_items_purchases_per_merchant
    se = SalesEngine.from_csv({ customers: "./test/better_samples/customers.csv", invoices: "./test/better_samples/invoices.csv", invoice_items: "./test/better_samples/invoice_items.csv", merchants: "./test/better_samples/merchants.csv" })
    customer = se.customers.find_by_id(3)

    assert_equal 29, customer.items_for_customer.values[0]
    assert_equal 41, customer.items_for_customer.values[1]
    assert_equal 39, customer.items_for_customer.values[2]
  end



end
