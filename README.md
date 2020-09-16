# Peperusha

Mpesa Client with better error handling and edge case protection.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'peperusha'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install peperusha

## Usage
### Intro
`N/B`: All the result below will respond to these;
```ruby
result.success? # either true or false
result.errors # an array of strings describing the errors, default is []
result.body # {body: body} if success otherwise {} 
```

To use `peperusha` first get the client token:
```ruby
result = Peperusha::Authenticate.call(
    consumer_key: consumer_key,
    consumer_secret: consumer_secret
)
result.body # returns the response body
result.body['access_token'] # the token to be used henceforth
result.body['expires_in'] # the time, in seconds, the token takes to expire
```

### Register urls
To ensure that customer to business calls work, you will have to register the callback urls:
```ruby
result = Peperusha::C2bRegisterUrls.call(
    token: token,
    business_number: business_number,
    confirmation_url: confirmation_url,
    validation_url: validation_url
)
result.body # returns the response body
```

### Payments
We can find the test credentials for these here `https://developer.safaricom.co.ke/test_credentials`

For customer to business send money via paybill do:
```ruby
result = Peperusha::CustomerPayViaPaybill.call(
    token: token,
    account_number: account_number,
    amount: amount,
    customer_number: customer_number,
    business_paybill_number: business_paybill_number
)
result.body # returns the response body
```

For customer to business send money via till do:
```ruby
result = Peperusha::CustomerPayViaTill.call(
    token: token,
    amount: amount,
    customer_number: customer_number,
    business_till_number: business_till_number
)
result.body # returns the response body
```

For business to customer send money do:
```ruby
result = Peperusha::BusinessToCustomer.call(
    amount: amount, # e.g 70
    business_number: business_number, # e.g 123454
    customer_number: customer_number, # e.g 254790123456
    initiator_name: initiator_name, # e.g John_Doe
    remarks: remarks,
    result_url: result_url, # url where to send notification upon processing of the payment request. 
    security_credential: security_credential, # e.g 32SzVdmCvjpmQfw3X2RK8UAv7xuhh304dXxFC5+3lslkk2TDJY/Lh6ESVwtqMxJzF7qA==
    timeout_url: timeout_url, # url where to send notification incase the payment request is timed out while awaiting processing in the queue.
    token: token # the access token
)
result.body # returns the response body
```

For business till to another business till number do:
```ruby
result = Peperusha::BusinessToTill.call(
    amount: amount, # e.g 70
    business_number1: business_number1, # e.g 123321
    business_number2: business_number2, # e.g 123456 should be a till number receiving the funds
    initiator_name: initiator_name, # e.g Business 1
    remarks: remarks,
    result_url: result_url, # url where to send notification upon processing of the payment request. 
    security_credential: security_credential, # e.g 32SzVdmCvjpmQfw3X2RK8UAv7xuhh304dXxFC5+3lslkk2TDJY/Lh6ESVwtqMxJzF7qA==
    timeout_url: timeout_url, # url where to send notification incase the payment request is timed out while awaiting processing in the queue.
    token: token # the access token
)
result.body # returns the response body
```

For business paybill to another business paybill number do:
```ruby
result = Peperusha::BusinessToPaybill.call(
    account_reference: account_reference, # e.g 123 the account value under the paybill
    amount: amount, # e.g 70
    business_number1: business_number1, # e.g 123321
    business_number2: business_number2, # e.g 123456 should be a paybill number receiving the funds
    initiator_name: initiator_name, # e.g Business 1
    remarks: remarks,
    result_url: result_url, # url where to send notification upon processing of the payment request. 
    security_credential: security_credential, # e.g 32SzVdmCvjpmQfw3X2RK8UAv7xuhh304dXxFC5+3lslkk2TDJY/Lh6ESVwtqMxJzF7qA==
    timeout_url: timeout_url, # url where to send notification incase the payment request is timed out while awaiting processing in the queue.
    token: token # the access token
)
result.body # returns the response body
```

### Inquiry
To check the status of a B2C and C2B APIs transactions:
```ruby
result = Peperusha::TransactionInquiry.call(
    token: token,
    initiator_name: initiator_name,
    receiving_number: receiving_number,
    remarks: remarks,
    result_url: result_url,
    security_credential: security_credential,
    timeout_url: timeout_url,
    transaction_id: transaction_id
)
```

### Reversal
To reverse a B2C APIs transactions:
```ruby
result = Peperusha::TransactionReversal.call(
    token: token,
    initiator_name: initiator_name,
    receiving_number: receiving_number,
    remarks: remarks,
    result_url: result_url,
    security_credential: security_credential,
    timeout_url: timeout_url,
    transaction_id: transaction_id,
)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sylvance/peperusha. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/sylvance/peperusha/blob/master/CODE_OF_CONDUCT.md). Other issues contact `peperusha.kakitu@gmail.com`.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Peperusha project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/sylvance/peperusha/blob/master/CODE_OF_CONDUCT.md).
