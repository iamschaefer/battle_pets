##
# Controller for viewing and updating services. This needs to be limited to admin users.
class ArenaServicesController < ApplicationController
  before_action :set_arena_service, only: [:show, :edit, :update, :destroy]

  # GET /arena_services
  # GET /arena_services.json
  def index
    @arena_services = ArenaService.all
  end

  # GET /arena_services/1
  # GET /arena_services/1.json
  def show
  end

  # GET /arena_services/new
  def new
    @arena_service = ArenaService.new
  end

  # GET /arena_services/1/edit
  def edit
  end

  # POST /arena_services
  # POST /arena_services.json
  def create
    @arena_service = ArenaService.new(arena_service_params)

    respond_to do |format|
      if @arena_service.save
        format.html { redirect_to @arena_service, notice: 'Arena service was successfully created.' }
        format.json { render :show, status: :created, location: @arena_service }
      else
        format.html { render :new }
        format.json { render json: @arena_service.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /arena_services/1
  # PATCH/PUT /arena_services/1.json
  def update
    respond_to do |format|
      if @arena_service.update(arena_service_params)
        format.html { redirect_to @arena_service, notice: 'Arena service was successfully updated.' }
        format.json { render :show, status: :ok, location: @arena_service }
      else
        format.html { render :edit }
        format.json { render json: @arena_service.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /arena_services/1
  # DELETE /arena_services/1.json
  def destroy
    @arena_service.destroy
    respond_to do |format|
      format.html { redirect_to arena_services_url, notice: 'Arena service was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_arena_service
    @arena_service = ArenaService.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def arena_service_params
    params.require(:arena_service).permit(:address, :port)
  end
end
