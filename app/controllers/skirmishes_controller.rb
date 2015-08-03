class SkirmishesController < ApplicationController
  before_action :set_skirmish, only: [:show, :edit, :update, :destroy]

  # GET /skirmishes
  # GET /skirmishes.json
  def index
    @skirmishes = Skirmish.all
  end

  # GET /skirmishes/1
  # GET /skirmishes/1.json
  def show
  end

  # GET /skirmishes/new
  def new
    @skirmish = Skirmish.new
  end

  # GET /skirmishes/1/edit
  def edit
  end

  # POST /skirmishes
  # POST /skirmishes.json
  def create
    @skirmish = Skirmish.new(skirmish_params)

    respond_to do |format|
      if @skirmish.save
        format.html { redirect_to @skirmish, notice: 'Skirmish was successfully created.' }
        format.json { render :show, status: :created, location: @skirmish }
      else
        format.html { render :new }
        format.json { render json: @skirmish.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /skirmishes/1
  # PATCH/PUT /skirmishes/1.json
  def update
    respond_to do |format|
      if @skirmish.update(skirmish_params)
        format.html { redirect_to @skirmish, notice: 'Skirmish was successfully updated.' }
        format.json { render :show, status: :ok, location: @skirmish }
      else
        format.html { render :edit }
        format.json { render json: @skirmish.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /skirmishes/1
  # DELETE /skirmishes/1.json
  def destroy
    @skirmish.destroy
    respond_to do |format|
      format.html { redirect_to skirmishes_url, notice: 'Skirmish was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_skirmish
      @skirmish = Skirmish.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def skirmish_params
      params.require(:skirmish).permit(:starts_at, :title)
    end
end
