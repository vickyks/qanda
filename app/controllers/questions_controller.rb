# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: %i[create edit update destroy]
  before_action :set_current_user

  def index
    @questions = Question.all
  end

  def show
    @question = Question.find(params[:id])
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)
    if @question.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to redirect_to questions_url, notice: "You've asked a question!" }
        format.json { head :no_content }
      end
    else
      render :new
    end
  end

  def edit
    @question = Question.find(params[:id])
  end

  def update
    @question = Question.find(params[:id])
    if @question.update(question_params)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to redirect_to questions_url, notice: 'You edited your question.' }
        format.json { head :no_content }
      end
    else
      render :edit
    end
  end

  def destroy
    @question = Question.find(params[:id])
    @question.destroy
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to questions_url, notice: 'Question deleted!' }
      format.json { head :no_content }
    end
  end

  private

  def question_params
    params.require(:question).permit(:text, :title)
  end

  def set_current_user
    @user = current_user
  end
end
