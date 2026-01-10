module Admin
  class ShowcasesController < Admin::BaseController
    before_action :set_showcase, only: [:show, :edit, :update, :destroy]

    def index
      @showcases = policy_scope(Showcase).order(created_at: :desc)
      authorize Showcase
    end

    def show
      authorize @showcase
    end

    def new
      @showcase = Showcase.new
      authorize @showcase
    end

    def edit
      authorize @showcase
    end

    def create
      @showcase = Showcase.new(showcase_params)
      authorize @showcase

      if @showcase.save
        redirect_to admin_showcase_path(@showcase), notice: t("admin.showcases.created")
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      authorize @showcase

      if @showcase.update(showcase_params)
        redirect_to admin_showcase_path(@showcase), notice: t("admin.showcases.updated")
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      authorize @showcase
      @showcase.destroy
      redirect_to admin_showcases_path, notice: t("admin.showcases.deleted")
    end

    private

    def set_showcase
      @showcase = Showcase.find(params[:id])
    end

    def showcase_params
      params.require(:showcase).permit(:title, :content, :image, :video, :symmetry_type)
    end
  end
end
