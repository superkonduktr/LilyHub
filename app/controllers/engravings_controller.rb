class EngravingsController < ApplicationController

  def index
    @engravings = Engraving.latest.paginate(page: params[:page], per_page: 10)
    respond_to do |format|
      format.html
      format.json do
        render json: @engravings.map { |e| engraving_view(e) }
      end
    end
  end

  def show
    @engraving = Engraving.find(params[:id])
    respond_to do |format|
      format.html
      format.js
      format.json { render json: engraving_view(@engraving) }
    end
  end

  def new
    @engraving = Engraving.new
  end

  def preview
    @engraving = Engraving.find(params[:id])
    render 'new'
  end

  def create
    @engraving = Engraving.new(engraving_params)
    @engraving.state = "new"
    @engraving.is_private = true if params[:preview]

    if @engraving.save
      EngravingWorker.perform_async(@engraving.id)
      if params[:preview]
        redirect_to preview_engraving_path(@engraving.id)
      else
        redirect_to engraving_path(@engraving.id)
      end
    else
      flash[:alert] = @engraving.errors.full_messages.join("; ")
      render 'new'
    end
  end

  def engraving_view(engraving)
    {
      state: engraving.state,
      text: engraving.text,
      author: engraving.author,
      created_at: engraving.created_at,
      error: engraving.error,
      url: engraving.url
    }
  end

  private

  def engraving_params
    params.require(:engraving).permit(:id, :text, :state, :is_private)
  end
end
