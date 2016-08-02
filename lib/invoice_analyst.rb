require_relative '../lib/statistics'
require 'pry'
class InvoiceAnalyst

  include Statistics

  def initialize(all_invoices)
    @all_invoices = all_invoices
  end

  def invoices_per_day
    @all_invoices.reduce(Array.new(7) {0}) do |days, invoice|
      days[invoice.created_at.wday] += 1
      days
    end
  end

  def top_days_by_invoice_count
    avg = mean(invoices_per_day)
    std_dev = standard_deviation(invoices_per_day)
    invoices_per_day.reduce([]) do |top_days, day|
      if day > (avg + std_dev)
        top_days << day_of_week(invoices_per_day.index(day))
      end
      top_days
    end
  end

  def day_of_week(index)
    days =
    {0 => "Sunday",
     1 => "Monday",
     2 => "Tuesday",
     3 => "Wednesday",
     4 => "Thursday",
     5 => "Friday",
     6 => "Saturday"}
     days[index]
   end

   def invoice_status(status_to_find)
     matching_invoices = @all_invoices.find_all do |invoice|
       invoice.status == status_to_find
     end
     ((matching_invoices.length.to_f / @all_invoices.length) * 100).round(2)
   end

   def fully_paid_invoices
     @all_invoices.find_all do |invoice|
       invoice.is_paid_in_full?
     end
   end

   def best_invoice_by_revenue
     fully_paid_invoices.max_by do |invoice|
       invoice.total
     end
   end

   def best_invoice_by_quantity
     fully_paid_invoices.max_by do |invoice|
       invoice.invoice_items.reduce(0) do |sum, invoice_item|
         sum += invoice_item.quantity
       end
     end
   end

end
