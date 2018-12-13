require "sinatra"
require_relative "authentication.rb"
require 'stripe'

set :publishable_key, ENV['PUBLISHABLE_KEY']
set :secret_key, ENV['SECRET_KEY']

Stripe.api_key = settings.secret_key
#the following urls are included in authentication.rb
# GET /login
# GET /logout
# GET /sign_up

# authenticate! will make sure that the user is signed in, if they are not they will be redirected to the login page
# if the user is signed in, current_user will refer to the signed in user object.
# if they are not signed in, current_user will be nil

if User.all(administrator: true).count == 0
  u = User.new
  u.email = "admin@admin.com"
  u.password = "admin"
  u.administrator = true
  u.save
end

get '/basket' do
    @basket = Basket.all
    erb :"basket/index"
end

get "/" do
	erb :index
end

get "/dashboard" do
	authenticate!
	erb :dashboard
end

get "/Shop_name" do
	erb :layout 
end

get '/new_item' do
	erb :new_item
end

 post '/new_item' do
	i = Item.new
	i.name = params["name"]
	i.description = params["description"]
	i.quantity = params["quantity"].to_i
	i.price = params["price"].to_i
	i.save
	redirect "/item_list"

end

get '/basket/payment' do
      @basket = Basket.all
      product = Basket.get(params[:id].to_i)
      items = Basket.all
      count = 0
      items.each {|x| 
      count +=   x.quantity * x.price
      }
      @sum_gross = count
      @totalcents = count * 100
      erb :"basket/payment"
end

post '/charge' do
	authenticate!
	if !current_user.pro && !current_user.administrator
  # Amount in cents
  count = 0
      items.each {|x| 
      count +=   x.quantity * x.price
      }
  @amount = count * 100

  customer = Stripe::Customer.create(
    :email => 'customer@example.com',
    :source  => params[:stripeToken]
  )

  charge = Stripe::Charge.create(
    :amount      => @amount,
    :description => 'Sinatra Charge',
    :currency    => 'usd',
    :customer    => customer.id
  )

  erb :charge
end
end

post '/basket' do
      if params["product_id"] && params["quantity"]
      	r = Item.get(params["product_id"].to_i)
      	if r.quantity >= params["quantity"].to_i

      		i = Basket.new
      		i.product_id = params["product_id"].to_i
      		i.quantity = params["quantity"].to_i
      		i.description = r.description
      		i.price = r.price
      		i.name = r.name
      		i.save

      		warehouse_to_delete = Item.get(params["product_id"].to_i)

      		if warehouse_to_delete && warehouse_to_delete.quantity >= params["quantity"].to_i
        	warehouse_to_delete.quantity -= params["quantity"].to_i
        	warehouse_to_delete.save
      		end

        redirect '/products/index'
      	else
        	status 404
        	erb :"error/warehouse_lack"
      	end
      else
      	return "Something went wrong"
      end
end


post '/basket/delete/:id' do
      quantity = Basket.get(params[:id].to_i)
      if quantity
        o = quantity.product_id
        k = quantity.quantity
        realitem = Item.get(o)
        realitem.quantity += k
        realitem.save
        quantity.destroy

        redirect '/basket'
      else
        status 404
        erb :"error/404"
      end
    end




get "/item_list" do
	@Items = Item.all
	#erb :item_list# orginal
	# the following is a table to display items
	erb :item_display_table

end


get "/delete item" do
		i = Item.get(params["name"])
		if i != nil
			i.destroy
			x = i.quantity.to_i
			x-1
			i.quantity = x
		end
end


  patch "/quantity" do
		i.quantity = params ["quantity"]

  end

require "sinatra"
require_relative "authentication.rb"

#the following urls are included in authentication.rb
# GET /login
# GET /logout
# GET /sign_up

# authenticate! will make sure that the user is signed in, if they are not they will be redirected to the login page
# if the user is signed in, current_user will refer to the signed in user object.
# if they are not signed in, current_user will be nil

get "/" do
	erb :index
end

get "/dashboard" do
	authenticate!
	erb :dashboard
end

get "/Shop_name" do
	erb :layout 
end

get '/new_item' do
	erb :new_item
end

 post '/new_item' do
	i = Item.new
	i.name = params["name"]
	i.description = params["description"]
	i.quantity = params["quantity"].to_i
	i.price = params["price"].to_i
	i.save
	redirect "/item_list"

end



get "/item_list" do
	@Items = Item.all
	#erb :item_list# orginal
	# the following is a table to display items
	erb :item_display_table

end

get '/product/:id' do
      i = Item.get(params[:id].to_i)
      if i 
      	@product = Item.get(params[:id].to_i)
        erb :"products/show"
      else
        status 404
        erb :"error/404"
      end
    end

get'/products/index' do
    @products = Item.all
    erb :"products/index"
end


get "/delete_item" do
		i = Item.get(params["name"])
		if i != nil
			i.destroy
			x = i.quantity.to_i
			x-1
			i.quantity = x
		end
end


  patch "/quantity" do
		i.quantity = params ["quantity"]

  end



# hash array to keep track of shoppers cart
# button to pay
# send email to owner at time of purchase