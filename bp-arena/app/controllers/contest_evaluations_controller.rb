class ContestEvaluationsController < ApplicationController
  before_action :set_contest_evaluation, only: [:show, :update, :destroy]

  # GET /contest_evaluations
  # GET /contest_evaluations.json
  def index
    @contest_evaluations = ContestEvaluation.all
  end

  # GET /contest_evaluations/1
  # GET /contest_evaluations/1.json
  def show
  end

  # POST /contest_evaluations
  # POST /contest_evaluations.json
  def create
    @contest_evaluation = ContestEvaluation.new(contest_evaluation_params.merge(callback_host: request.remote_ip))

    if @contest_evaluation.save && @contest_evaluation.start_job
      render :show, status: :created, location: @contest_evaluation
    else
      render json: @contest_evaluation.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /contest_evaluations/1
  # PATCH/PUT /contest_evaluations/1.json
  def update
    if @contest_evaluation.update(contest_evaluation_params)
      render :show, status: :ok, location: @contest_evaluation
    else
      render json: @contest_evaluation.errors, status: :unprocessable_entity
    end
  end

  # DELETE /contest_evaluations/1
  # DELETE /contest_evaluations/1.json
  def destroy
    @contest_evaluation.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_contest_evaluation
    @contest_evaluation = ContestEvaluation.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contest_evaluation_params
    params.permit(:contest_id, :challenger, :challenged, :contest_type)
  end
end
