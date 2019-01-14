SimpleCov.start do
    minimum_coverage 100
    if ENV['CI']
        require 'codecov'
        SimpleCov.formatter = SimpleCov::Formatter::Codecov
    end
end
