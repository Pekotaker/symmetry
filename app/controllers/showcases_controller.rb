class ShowcasesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_showcase, only: [:show]

  def index
    @showcases = Showcase.order(created_at: :desc)
  end

  def show; end

  private

  def set_showcase
    @showcase = Showcase.find(params[:id])
  end
end
