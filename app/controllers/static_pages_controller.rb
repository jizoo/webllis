class StaticPagesController < Base
  skip_before_action :authorize

  def home
  end

  def about
  end

  def contact
  end
end
