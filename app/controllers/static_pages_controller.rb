class StaticPagesController < ApplicationController
  skip_before_action :require_login, only: %i[top form policy term]

  def top; end

  def form; end

  def policy; end

  def term; end
end
