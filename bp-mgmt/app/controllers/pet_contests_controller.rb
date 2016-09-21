##
# Controller for endpoints to our PetContests model
class PetContestsController < ApplicationController
  before_action :set_pet_contest, only: [:show, :edit, :update, :destroy, :accept, :cancel, :complete]
  # This is helpful in development when the services are running on the same machine
  skip_before_action :verify_authenticity_token, only: [:complete, :accept, :cancel]

  # GET /pet_contests
  # GET /pet_contests.json
  def index
    @pet_contests = PetContest.all
  end

  # GET /pet_contests/1
  # GET /pet_contests/1.json
  def show
  end

  # GET /pet_contests/new
  def new
    @pet_contest = PetContest.new
  end

  def by_user
    @pet_contests = PetContest.by_user(pet_contest_by_user_params)
    respond_to do |format|
      format.html { render :index }
      format.json { render :index, status: :ok, location: @pet_contest }
    end
  end

  def by_pet
    @pet_contests = PetContest.by_user(pet_contest_by_pet_params)
    respond_to do |format|
      format.html { render :index }
      format.json { render :index, status: :ok, location: @pet_contest }
    end
  end

  def request_contest
    @request_response = PetContest.new(pet_contest_request_params)
  end

  # POST /pet_contests
  # POST /pet_contests.json
  def create
    @pet_contest = PetContest.new(pet_contest_params)
    respond_to do |format|
      if @pet_contest.save
        format.html { redirect_to @pet_contest, notice: 'Pet contest was successfully created.' }
        format.json { render :show, status: :created, location: @pet_contest }
      else
        format.html { render :new }
        format.json { render json: @pet_contest.errors, status: :unprocessable_entity }
      end
    end
  end

  def complete
    params = pet_contest_complete_params
    respond_to do |format|
      if @pet_contest.complete!(params[:winner_id])
        format.html { redirect_to @pet_contest, notice: 'Pet contest was successfully updated.' }
        format.json { render plain: @pets_contest.to_json }
      else
        format.html { render :edit }
        format.json { render json: @pet_contest.errors, status: :unprocessable_entity }
      end
    end
  end

  def accept
    respond_to do |format|
      if @pet_contest.accept!
        format.html { redirect_to @pet_contest, notice: 'Pet contest was successfully updated.' }
        format.json { render :show, status: :ok, location: @pet_contest }
      else
        format.html { render :edit }
        format.json { render json: @pet_contest.errors, status: :unprocessable_entity }
      end
    end
  end

  def cancel
    respond_to do |format|
      if @pet_contest.cancel!
        format.html { redirect_to @pet_contest, notice: 'Pet contest was successfully updated.' }
        format.json { render :show, status: :ok, location: @pet_contest }
      else
        format.html { render :edit }
        format.json { render json: @pet_contest.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_pet_contest
    @pet_contest = PetContest.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def pet_contest_params
    params.require(:pet_contest).permit(:contest_type, :challenger_id, :challenged_id)
  end

  def pet_contest_complete_params
    params.permit(:id, :winner_id, :format)
  end

  def pet_contest_by_user_params
    params.require(:id)
  end

  def pet_contest_by_pet_params
    params.require(:id)
  end
end
