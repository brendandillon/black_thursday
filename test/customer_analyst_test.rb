require './test/test_helper'
require './lib/sales_analyst'

class CustomerAnalystTest < Minitest::Test

  def test_it_can_find_the_total_for_a_customer
    se = SalesEngine.from_csv({ customers: "./test/better_samples/customers.csv", merchants: "./test/better_samples/merchants.csv", invoices: "./test/better_samples/invoices.csv", invoice_items: "./test/better_samples/invoice_items.csv", transactions: "./test/better_samples/transactions.csv" })
    ca = SalesAnalyst.new(se).customer_analyst
    customer = se.customers.find_by_id(1)

    assert_equal BigDecimal(88758.65, 7), ca.total_for_customer(customer)
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
    se = SalesEngine.from_csv({ customers: "./test/better_samples/customers.csv", merchants: "./test/better_samples/merchants.csv", invoices: "./test/better_samples/invoices.csv", invoice_items: "./test/better_samples/invoice_items.csv" })
    ca = SalesAnalyst.new(se).customer_analyst

    assert_equal "Sylvester", ca.top_buyers[0].first_name
  end

  def test_that_top_merchant_for_customer_finds_top_merchant
    se = SalesEngine.from_csv({ customers: "./test/better_samples/customers.csv", merchants: "./test/better_samples/merchants.csv", invoices: "./test/better_samples/invoices.csv", invoice_items: "./test/better_samples/invoice_items.csv" })
    ca = SalesAnalyst.new(se).customer_analyst

    assert_equal "FrenchyTrendy", ca.top_merchant_for_customer(3).name
  end

  def test_that_one_time_buyers_finds_customers_with_one_invoice
    se = SalesEngine.from_csv({ customers: "./test/better_samples/customers.csv", merchants: "./test/better_samples/merchants.csv", invoices: "./test/better_samples/invoices.csv", invoice_items: "./test/better_samples/invoice_items.csv", transactions: "./test/better_samples/transactions.csv" })
    ca = SalesAnalyst.new(se).customer_analyst

    assert_equal true, ca.one_time_buyers.is_a?(Array)
    assert_equal 2, ca.one_time_buyers.length
    assert_equal "Mariah", ca.one_time_buyers[0].first_name
  end


  def test_that_all_one_time_buyers_items_maps_all_otb_items_into_an_array
    se = SalesEngine.from_csv({ customers: "./test/better_samples/customers.csv", merchants: "./test/better_samples/merchants.csv", invoices: "./test/better_samples/invoices.csv", invoice_items: "./test/better_samples/invoice_items.csv", items: "./test/better_samples/items.csv", transactions: "./test/better_samples/transactions.csv" })
    ca = SalesAnalyst.new(se).customer_analyst

    assert_equal true, ca.all_one_time_buyers_items.is_a?(Array)
    assert_equal 13, ca.all_one_time_buyers_items.length
    assert_equal true, ca.all_one_time_buyers_items[0].is_a?(Item)
  end

  def test_that_one_time_buyers_item_count_creates_a_hash_to_point_items_to_their_count
    se = SalesEngine.new({})
    ca = SalesAnalyst.new(se).customer_analyst
    items = ["a" ,"a" ,"a", "b","b" ,"c"]
    item_count = { "a" => 3, "b" => 2, "c" => 1 }

    assert_equal true, ca.one_time_buyers_item_count(items).is_a?(Hash)
    assert_equal 3, ca.one_time_buyers_item_count(items).length
    assert_equal item_count, ca.one_time_buyers_item_count(items)
  end

  def test_that_it_can_group_one_time_buyers_group_by_count
    se = SalesEngine.new({})
    ca = SalesAnalyst.new(se).customer_analyst
    item_count = { "a" => 2, "b" => 2, "c" => 1 }
    item_count_group = { 2 => ["a", "b"], 1 => ["c"]}

    assert_equal true, ca.one_time_buyers_group_by_count(item_count).is_a?(Hash)
    assert_equal item_count_group, ca.one_time_buyers_group_by_count(item_count)
  end

  def test_that_one_time_buyers_item_finds_item_most_otbs_bought
    se = SalesEngine.new({})
    ca = SalesAnalyst.new(se).customer_analyst
    item_count = { "a" => 2, "b" => 2, "c" => 1 }
    item_count_group = { 2 => ["a", "b"], 1 => ["c"]}
    ca.stub :one_time_buyers_group_by_count, { 2 => ["a", "b"], 1 => ["c"]} do
      assert_equal ["a", "b"], ca.one_time_buyers_items
    end
  end

  def test_items_bought_in_year_finds_number_items_bought_for_given_year
    se = SalesEngine.from_csv({ customers: "./test/better_samples/customers.csv", merchants: "./test/better_samples/merchants.csv", invoices: "./test/better_samples/invoices.csv", invoice_items: "./test/better_samples/invoice_items.csv", items: "./test/better_samples/items.csv", transactions: "./test/better_samples/transactions.csv" })
    ca = SalesAnalyst.new(se).customer_analyst

    assert_equal 1, ca.items_bought_in_year(5, 2012).length
  end

  def test_it_can_find_all_invoices_in_a_year
    se = SalesEngine.from_csv({ customers: "./test/better_samples/customers.csv", merchants: "./test/better_samples/merchants.csv", invoices: "./test/better_samples/invoices.csv", invoice_items: "./test/better_samples/invoice_items.csv", items: "./test/better_samples/items.csv", transactions: "./test/better_samples/transactions.csv" })
    ca = SalesAnalyst.new(se).customer_analyst
    customer = ca.find_customer(5)

    assert_equal 1, ca.invoices_in_year(2012, customer).length
  end

  def test_that_it_can_find_most_recent_invoices
    se = SalesEngine.from_csv({ customers: "./test/better_samples/customers.csv", merchants: "./test/better_samples/merchants.csv", invoices: "./test/better_samples/invoices.csv", invoice_items: "./test/better_samples/invoice_items.csv", items: "./test/better_samples/items.csv", transactions: "./test/better_samples/transactions.csv" })
    ca = SalesAnalyst.new(se).customer_analyst
    customer = ca.find_customer(5)

    assert_equal true, ca.most_recent_invoices(customer).is_a?(Array)
    assert_equal 1, ca.most_recent_invoices(customer).length
    assert_equal 17, ca.most_recent_invoices(customer)[0].id
  end

  def test_that_it_can_find_most_recently_bought_items
    se = SalesEngine.from_csv({ customers: "./test/better_samples/customers.csv", merchants: "./test/better_samples/merchants.csv", invoices: "./test/better_samples/invoices.csv", invoice_items: "./test/better_samples/invoice_items.csv", items: "./test/better_samples/items.csv", transactions: "./test/better_samples/transactions.csv" })
    ca = SalesAnalyst.new(se).customer_analyst
    customer = ca.find_customer(5)

    assert_equal true, ca.most_recently_bought_items(5).is_a?(Array)
    assert_equal 4, ca.most_recently_bought_items(5).length
    assert_equal 263424379, ca.most_recently_bought_items(5)[0].id
  end

  def test_customers_with_unpaid_invoices_finds_customers_who_have_invoices_not_paid_in_full
    se = SalesEngine.from_csv({ customers: "./test/better_samples/customers.csv", merchants: "./test/better_samples/merchants.csv", invoices: "./test/better_samples/invoices.csv", invoice_items: "./test/better_samples/invoice_items.csv", items: "./test/better_samples/items.csv", transactions: "./test/better_samples/transactions.csv" })
    ca = SalesAnalyst.new(se).customer_analyst

    assert_equal true, ca.customers_with_unpaid_invoices.is_a?(Array)
    assert_equal 4, ca.customers_with_unpaid_invoices.length
  end

end
