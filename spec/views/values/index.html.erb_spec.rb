require 'rails_helper'

RSpec.describe "values/index" do
   @values = []
   
   context "Verify correct balance page" do 
      before(:each) do

         @values = [         
            Value.create!(:value => 122365.24),
            Value.create!(:value => 599.00),
            Value.create!(:value => 850139.99),
            Value.create!(:value => 23329.50),
            Value.create!(:value => 566.27),      
          ]
      end
      
      it "verify the right number of values appear on the screen" do
         render
         cycle(@values.length) do  |i| 
            value_m = "Value " + i.to_s
            expect(rendered).to include(value_m) 
        end
      end
      
      it "verify the values on the screen are greater than 0" do
         render      
         currency_vals = []
         # scan for exact "$", one or more digit, one or zero ",", more digit, "." two digits
         rendered.scan(/\$\d+\,?\d+\.\d{2}/) { |val| currency_vals << val }  
         vals = []            
         # take only digit and '.', other chars to ''
         currency_vals.each { |c_val| vals << c_val.gsub(/[^\d\.]/, '').to_f }
         vals.each do |val|
            expect(val).to be > 0
         end       
      end
      
      it "verify the total balance is correct based on the values listed on the screen" do   
         pages_ctl = PagesController.new 
         balance = pages_ctl.balance
         # get the values listed on the screen, then add them up, and compare
         render      
         currency_vals = []
         # scan for exact "$", one or more digit, one or zero ",", more digit, "." two digits
         rendered.scan(/\$\d+\,?\d+\.\d{2}/) { |val| currency_vals << val }  
         vals = []       
         # take only digit and '.', other chars to ''
         currency_vals.each { |c_val| vals << c_val.gsub(/[^\d\.]/, '').to_f }
         sum_screen_values = vals.reduce(:+)
         expect(balance).to eq(sum_screen_values)
      end    
                 
      it "verify the values are formatted as currencies" do                         
         render
         expect(rendered).to match /\$122,365.24/   
         expect(rendered).to match /\$599.00/  
         expect(rendered).to match /\$850,139.99/  
         expect(rendered).to match /\$23,329.50/  
         expect(rendered).to match /\$566.27/  
      end    
  
      it "verify the total balance matches the sum of the values" do 
         # I need to provide @balance for partial balance 
         pages_ctl = PagesController.new 
         @balance = pages_ctl.balance    
         vals = []
         @values.each { |v| vals << v.value }       
         vals_sum = vals.reduce(:+)       
         render  :partial => "values/balance.html.erb"
         currency_sum =  rendered.scan(/\$\d+\,?\d+\.\d{2}/)     # take out only one currency value
         screen_sum = currency_sum[0].to_s.gsub(/[^\d\.]/, '').to_f    # take out chars not digit or '.'
         expect(screen_sum).to eq(vals_sum)         
      end  
      
      it "create a mockup values and result" do
         # create mockup for Value class    
         values = []
         values << instance_double("Value", :value => 122365.24)
         values << instance_double("Value", :value => 599.00)
         values << instance_double("Value", :value => 850139.99)
         values << instance_double("Value", :value => 23329.50)
         values << instance_double("Value", :value => 566.27)
         
         #creat mockup for Page class  
         vals = []
         values.each do |val|
            vals << val.value
         end         
         vals_sum = vals.reduce(:+)
         page = double("page")
         allow(page).to receive(:balance).and_return(vals_sum) 
         expect(page.balance).to eq(vals_sum)                      
      end               
   end      
end






