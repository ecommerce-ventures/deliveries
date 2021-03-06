# Deliveries Gem

Deliveries is a gem that gives you the ability to integrate multiple shipping services through different couriers

## Installation

Add the following line to your Gemfile

```ruby
gem 'deliveries'
```
Then run:

```bash
bundle install
```

## Configuration

Each courier requires a different configuration, below we will leave some examples

#### 1. Mondial Relay
```ruby
Deliveries.courier(:mondial_relay).configure do |config|
  config.mondial_relay_merchant = '...'
  config.mondial_relay_key = '...'
end
```

#### 2. Mondial Relay Dual
```ruby
Deliveries.courier(:mondial_relay_dual).configure do |config|
  config.dual_carrier_login = '...'
  config.dual_carrier_password = '...'
  config.dual_carrier_customer_id = '...'
  config.countries = {
    fr: {
      home_delivery_mode: 'HOC'
    },
    de: {
      home_delivery_mode: 'HOM'
    },
    gb: {
      home_delivery_mode: 'HOM'
    }
 }
end
```

#### 3. Correos Express
```ruby
Deliveries.courier(:correos_express).configure do |config|
  config.username = '...'
  config.password = '...'
  config.client_code = '...'
  config.shipment_sender_code = '...'
  config.pickup_receiver_code = '...'
  config.countries = {
    es: {
      product: '93'
    },
    pt: {
      product: '63'
    }
  }
end
```

#### 4. Spring
```ruby
Deliveries.courier(:spring).configure do |config|
  config.api_key = '...'
  config.countries = {
    gb: {
      service: 'TRCK'
    },
    it: {
      service: 'TRCK'
    }
   }
   config.default_product = {
    description: 'ROPA',
    hs_code: '',
    origin_country: 'ES',
    quantity: 1,
    value: 100
  }
end
```

#### 5. UPS
```ruby
Deliveries.courier(:ups).configure do |config|
  config.license_number = '...'
  config.username = '...'
  config.password = '...'
  config.point_account_number = '...'
  config.home_account_number = '...'
  config.default_product = {
    description: 'clothes',
    weight: '1'
  }
end
```

#### Time Zone

This library uses Active Support's Time extension, so a time zone must be set before using it:

```ruby
require 'active_support/time'

# Configure time zone
Time.zone = 'Madrid'
```

## Usage

#### Get collection point by country and postcode

```ruby
# Example Using Ups

Deliveries.courier(:ups).get_collection_points(postcode: '...', country: 'it')
```
#### Get collection point info

```ruby
# Example Using Mondial Relay

Deliveries.courier(:mondial_relay).get_collection_point(global_point_id: 'mondial_relay~fr~00000~XXXXXX')
```

#### Create a Shipment
```ruby
# Example Using Correos Express

sender = Deliveries::Address.new(
  name: '...',
  email: 'sender@example.com',
  phone: '...',
  country: 'ES',
  state: '...',
  city: '...',
  street: '...',
  postcode: '...'
)

receiver = Deliveries::Address.new(
  name: '...',
  email: 'receiver@example.com',
  phone: '...',
  country: 'ES',
  state: '...',
  city: '...',
  street: '...',
  postcode: '...'
)

response = Deliveries.courier(:correos_express).create_shipment(
  sender: sender,
  receiver: receiver,
  collection_point: nil,
  parcels: 1,
  reference_code: '...',
  shipment_date: Date.tomorrow,
  remarks: nil
)
```

#### Create a Pickup
```ruby
# Example Using Spring

sender = Deliveries::Address.new(
  name: '...',
  email: 'sender@example.com',
  phone: '...',
  country: 'ES',
  state: '...',
  city: '...',
  street: '...',
  postcode: '...'
)

receiver = Deliveries::Address.new(
  name: '...',
  email: 'receiver@example.com',
  phone: '...',
  country: 'ES',
  state: '...',
  city: '...',
  street: '...',
  postcode: '...'
)

response = Deliveries.courier(:spring).create_pickup(
  sender: sender,
  receiver: receiver,
  parcels: 1,
  reference_code: '...',
  pickup_date: 2.days.since.to_date
)
```

#### Download a Label
```ruby
# Example Using Spring

label = Deliveries.courier(:spring).get_label(tracking_code: '...')

# And then, we can use it as follows

File.write('label.pdf', label.raw)
```

## License
[MIT](https://choosealicense.com/licenses/mit/)
