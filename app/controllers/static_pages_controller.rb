class StaticPagesController < ApplicationController
  skip_before_action :authorize

  def about
  end
end
