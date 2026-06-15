class Admin::BaseController < ApplicationController
  include Pagy::Backend
  before_action :require_admin
  layout "admin"
end
