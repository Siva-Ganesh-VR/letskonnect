class Organizer::BaseController < ApplicationController
  include Pagy::Backend
  before_action :require_organizer
  layout "organizer"
end
