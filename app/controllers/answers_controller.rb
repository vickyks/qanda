class AnswersController < ApplicationController
  before_action :set_question
  before_action :set_answer, except: [:index, :new, :create]

  def index
    @answers = @question.answers
  end

  def new
    @question = Question.find(params[:question_id])
    @answer = Answer.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    if @answer.save
      redirect_to [@question, @answer], notice: "Thanks for answering #{@question.user}'s question!"
    else
      render :new
    end
  end

  def update
    if @answer.update(answer_params)
      redirect_to [@question, @answer], notice: "You changed your answer"
    else
      render :edit
    end
  end

  def destroy
    @answer.destroy
    redirect_to question_answers_url(@question), notice: "You deleted your answer!"
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = @question.answers.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:text)
  end
end
