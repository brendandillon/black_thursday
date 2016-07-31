require './test/test_helper'
require './lib/sales_analyst'

class CustomerAnalystTest < Minitest::Test

  def test_it_can_find_the_total_for_a_customer
    se = SalesEngine.from_csv({ customers: "./test/samples/customers_sample.csv", merchants: "./test/samples/merchants_sample.csv", invoices: "./test/samples/invoices_sample.csv", invoice_items: "./test/samples/invoice_items_sample.csv" })
    ca = SalesAnalyst.new(se).customer_analyst
    customer = se.customers.find_by_id(1)

    assert_equal BigDecimal(120881.31, 8), ca.total_for_customer(customer)
  end

  def test_it_finds_the_top_20_buyers_by_default
    se = SalesEngine.from_csv({ customers: "./test/samples/customers_sample.csv", merchants: "./test/samples/merchants_sample.csv", invoices: "./test/samples/invoices_sample.csv", invoice_items: "./test/samples/invoice_items_sample.csv" })
    ca = SalesAnalyst.new(se).customer_analyst

    assert_equal true, ca.top_buyers.is_a?(Array)
    assert_equal 20, ca.top_buyers.length
  end

  def test_it_can_find_the_top_3_buyers
    se = SalesEngine.from_csv({ customers: "./test/samples/customers_sample.csv", merchants: "./test/samples/merchants_sample.csv", invoices: "./test/samples/invoices_sample.csv", invoice_items: "./test/samples/invoice_items_sample.csv" })
    ca = SalesAnalyst.new(se).customer_analyst

    assert_equal true, ca.top_buyers(3).is_a?(Array)
    assert_equal 3, ca.top_buyers(3).length
  end

  def test_the_top_buyers_are_customers
    se = SalesEngine.from_csv({ customers: "./test/samples/customers_sample.csv", merchants: "./test/samples/merchants_sample.csv", invoices: "./test/samples/invoices_sample.csv", invoice_items: "./test/samples/invoice_items_sample.csv" })
    ca = SalesAnalyst.new(se).customer_analyst

    assert_equal true, ca.top_buyers[0].is_a?(Customer)
  end

  def test_the_top_buyer_is_the_highest_spending_customer
    se = SalesEngine.from_csv({ customers: "./test/samples/customers_sample.csv", merchants: "./test/samples/merchants_sample.csv", invoices: "./test/samples/invoices_sample.csv", invoice_items: "./test/samples/invoice_items_sample.csv" })
    ca = SalesAnalyst.new(se).customer_analyst

    assert_equal "Joey", ca.top_buyers[0].first_name
  end

end
