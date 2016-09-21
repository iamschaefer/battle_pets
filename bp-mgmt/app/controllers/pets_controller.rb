##
# Controller for Pets
class PetsController < ApplicationController
  before_action :set_pet, only: [:show, :update, :destroy]

  # GET users/:id/pets
  # GET users/:id/pets.json
  def index
    @pets = Pet.where(user_id: params[:id])
  end

  def leader_board
    @pets = Pet.leaders
    respond_to do |format|
      format.html { render plain: @pets }
      format.json { render plain: @pets.to_json }
    end
  end

  # GET /pets/1
  # GET /pets/1.json
  def show
  end

  # GET /pets/types
  # GET /pets/types.json
  def types
    respond_to do |format|
      pet_types = Pet.pet_types
      format.html { render plain: pet_types }
      format.json { render plain: pet_types.to_json }
    end
  end

  # POST users/:id/pets
  # POST users/:id/pets.json
  def create
    @pet = Pet.new_by_type(create_pet_params)

    respond_to do |format|
      if @pet.save
        format.html { redirect_to @pet, notice: 'Pet was successfully created.' }
        format.json { render :show, status: :created, location: @pet }
      else
        format.html { render :new }
        format.json { render json: @pet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pets/1
  # DELETE /pets/1.json
  # TODO need to make sure nulls are allowed in DB
  def destroy
    @pet.destroy
    respond_to do |format|
      format.html { redirect_to pets_url, notice: 'Pet was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_pet
    @pet = Pet.find(params[:id])
  end

  # We determine the strength, wit, experience, etc. Don't allow users to submit those parameters
  def create_pet_params
    params.require(:pet).permit(:user_id, :name, :pet_type).merge(user_id: params.require(:user_id))
  end
end
