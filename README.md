[![ruby](https://img.shields.io/badge/ruby-v2.5.1-green.svg)](https://www.ruby-lang.org/en/)
[![rails](https://img.shields.io/badge/rails-v5.2.3-orange.svg)](https://rubyonrails.org/)

## Showoff

[https:/showoff-tech-test-1.herokuapp.com](https://showoff-tech-test-1.herokuapp.com)

## Installation

**Dependencies**: Before installation make sure you have Ruby (2.5.1) and Rails (5.2.3) installed. 

1. Clone the Project

	~~~ sh
	git clone https://github.com/caiodsc/project.git
	~~~

2. Bundle

	~~~ sh
	bundle install
	~~~

3. Fill the .env with your credentials

4. Start the Application

	~~~ sh
	rails s
	~~~


## Testing with RSpec

The project was built with **TDD (Test Driven Development)** and has a Full Test Suite. To execute the tests just run the tests with RSpec.
The project also uses [VCR](https://github.com/vcr/vcr) to record test suite's HTTP interactions.

1. Run tests

    ~~~ sh
    bundle exec rspec
    ~~~

## Running multiple environments

The project was build using the gem [dotenv](https://github.com/bkeepers/dotenv). In order to run multiple environments as test, development and production, it's necessary to create the related files: **.env.test**, **.env.development**, **.env.production**. [Read more](https://github.com/bkeepers/dotenv#what-other-env-files-can-i-use).
