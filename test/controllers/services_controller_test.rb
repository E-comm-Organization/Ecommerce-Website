# frozen_string_literal: true

require 'test_helper'

class ServicesControllerTest < ActionDispatch::IntegrationTest
  test 'should get About' do
    get services_About_url
    assert_response :success
  end

  test 'should get service' do
    get services_service_url
    assert_response :success
  end

  test 'should get policy' do
    get services_policy_url
    assert_response :success
  end

  test 'should get FAQ' do
    get services_FAQ_url
    assert_response :success
  end
end
