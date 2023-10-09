require 'stripe'
require 'json'

Stripe.api_key = "sk_testXXXXXXXXX"

def is_from_country?(billing, shipping, country)
    if billing.nil? && shipping.nil?
        return false
    end
    return ((!billing.nil? && (billing["country"].downcase == country)) || (!shipping.nil? && (shipping["address"]["country"].downcase == country)))
end


country = 'us'
filtered_customers = []
starting_after = nil
begin
    customers = Stripe::Customer.list(limit: 100, starting_after: starting_after)
    customers.each do |customer| 
        if is_from_country?(customer.address, customer.shipping, country)
            filtered_customers.push(customer)
        end
        starting_after = customer.id
    end
end while customers.has_more
puts filtered_customers.length()
