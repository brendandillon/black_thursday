# Black Thursday
By Brian Heim and Brendan Dillon
***
## Description
**Black Thursday** is a platform for e-commerce data that provides search
functionality and sales analytics.
***

## Installation
To install necessary gems, run the following command from the project root:
```
bundle
```
***

## Usage
Black Thursday takes input in CSV format. A number of data files are included
that demonstrate the acceptable syntax and headers for input.

It is able to handle these types of input:
* Customers
* Merchants
* Items
* Invoices
* Invoice Items
* Transactions

These CSV files can be loaded into a sales engine with the following command:
```ruby
sales_engine = SalesEngine.from_csv({
  customers:     "file_path_of_customers.csv",
  merchants:     "file_path_of_merchants.csv",
  items:         "file_path_of_items.csv"
  invoices:      "file_path_of_invoices.csv",
  invoice_items: "file_path_of_invoice_items.csv",
  transactions:  "file_path_of_transactions.csv"
  })
```

Note that you do not need to upload a file for every type of input.
For example, if you only have customer data,
```ruby
sales_engine = SalesEngine.from_csv({
  customers: "file_path_of_customers.csv"
  })
```
would be an acceptable input.  
However, some analytics may not work without loading all input types.

To search for a customer by their ID, run:
```ruby
sales_engine.customers.search_by_id(id of the customer)
```
Black Thursday is likewise able to search for any of the possible input types by a number of different criteria.

To run analytics, initialize a sales analyst like so:
```ruby
sales_analyst = SalesAnalyst.new(sales_engine)
```

The sales analyst is able to run the following analytic methods:
* golden_items
* average_items_per_merchant
* average_items_per_merchant_standard_deviation
* merchants_with_high_item_count
* average_item_price_for_merchant
* average_average_price_per_merchant
* average_invoices_per_merchant
* average_invoices_per_merchant_standard_deviation
* top_merchants_by_invoice_count
* bottom_merchants_by_invoice_count
* top_days_by_invoice_count
* invoice_status
* best_invoice_by_revenue
* best_invoice_by_quantity
* top_buyers
* top_merchant_for_customer
* one_time_buyers
* one_time_buyers_items
* items_bought_in_year
* customers_with_unpaid_invoices
***
## Authors
Brian Heim  
Brendan Dillon
