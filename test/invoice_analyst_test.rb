require './test/test_helper'
require './lib/sales_analyst'

class InvoiceAnalystTest < Minitest::Test

  def test_it_knows_the_number_of_invoices_created_on_each_day_of_the_week
    se = SalesEngine.from_csv({ items: "./test/samples/item_sample.csv", merchants: "./test/samples/merchants_sample.csv", invoices: "./test/samples/invoices_sample.csv" })
    ina = SalesAnalyst.new(se).invoice_analyst

    assert_equal true, ina.invoices_per_day.is_a?(Array)
    assert_equal 7, ina.invoices_per_day.length
  end

  def test_it_knows_which_days_of_the_week_have_the_most_sales
    se = SalesEngine.from_csv({ items: "./test/samples/item_sample.csv", merchants: "./test/samples/merchants_sample.csv", invoices: "./test/samples/invoices_sample.csv" })
    ina = SalesAnalyst.new(se).invoice_analyst

    assert_equal ["Friday"], ina.top_days_by_invoice_count
  end

  def test_that_it_finds_distribution_of_invoice_status
    se = SalesEngine.from_csv({ items: "./test/samples/item_sample.csv", merchants: "./test/samples/merchants_sample.csv", invoices: "./test/samples/invoices_sample.csv" })
    ina = SalesAnalyst.new(se).invoice_analyst

    assert_equal 29.00, ina.invoice_status(:pending)
    assert_equal 63.00, ina.invoice_status(:shipped)
    assert_equal 8.00, ina.invoice_status(:returned)
  end

  def test_best_invoice_by_revenue_finds_highest_grossing_invoice
    se = SalesEngine.from_csv({ items: "./test/better_samples/items.csv", merchants: "./test/better_samples/merchants.csv", invoices: "./test/better_samples/invoices.csv", invoice_items: "./test/better_samples/invoice_items.csv", transactions: "./test/better_samples/transactions.csv" })
    ina = SalesAnalyst.new(se).invoice_analyst

    assert_equal 22, ina.best_invoice_by_revenue.id
  end

  def test_best_invoice_by_quantity_finds_invoice_with_most_items
    se = SalesEngine.from_csv({ items: "./test/better_samples/items.csv", merchants: "./test/better_samples/merchants.csv", invoices: "./test/better_samples/invoices.csv", invoice_items: "./test/better_samples/invoice_items.csv", transactions: "./test/better_samples/transactions.csv" })
    ina = SalesAnalyst.new(se).invoice_analyst

    assert_equal 1, ina.best_invoice_by_quantity.id
  end

  def test_it_can_find_fully_paid_invoices
    se = SalesEngine.from_csv({ items: "./test/better_samples/items.csv", merchants: "./test/better_samples/merchants.csv", invoices: "./test/better_samples/invoices.csv", invoice_items: "./test/better_samples/invoice_items.csv", transactions: "./test/better_samples/transactions.csv" })
    ina = SalesAnalyst.new(se).invoice_analyst

    assert_equal 17, ina.fully_paid_invoices.length
  end

end
