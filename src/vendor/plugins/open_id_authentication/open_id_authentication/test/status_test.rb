require 'test/unit'

RAILS_ROOT = File.dirname(__FILE__) unless defined? RAILS_ROOT
require File.dirname(__FILE__) + "/../lib/open_id_authentication"

class StatusTest < Test::Unit::TestCase
  include OpenIdAuthentication

  def test_all_error_codes_should_compare_to_unsuccessful
    assert Result[:missing] === :unsuccessful
    assert Result[:missing] === :missing
  end

  def test_state_conditional
    assert Result[:missing].missing?
    assert Result[:missing].unsuccessful?
    assert !Result[:missing].successful?

    assert Result[:successful].successful?
    assert !Result[:successful].unsuccessful?
  end
end