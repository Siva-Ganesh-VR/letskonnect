class Attendee::BaseController < ApplicationController
  include Pagy::Backend
  before_action :require_attendee
  layout "attendee"
end
