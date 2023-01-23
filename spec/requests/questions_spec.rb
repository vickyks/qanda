# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Questions', type: :request do
  let(:user) { create(:user) }
  let(:valid_attributes) { attributes_for(:question) }
  let(:invalid_attributes) { attributes_for(:question, title: nil) }

  before(:each) do
    sign_in user
  end

  describe "GET /questions" do
    it "returns a success response" do
      create_list(:question, 5)
      get questions_path
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /questions/new" do
    it "returns a success response" do
      get new_question_path
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /questions" do
    context "with valid params" do
      it "creates a new Question" do
        expect {
          post questions_path, params: { question: valid_attributes }
        }.to change(Question, :count).by(1)
      end

      it "redirects to the created question" do
        post questions_path, params: { question: valid_attributes }
        expect(response).to redirect_to(Question.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post questions_path, params: { question: invalid_attributes }
        expect(response).to have_http_status(200)
      end
    end
  end

    describe "GET /questions/:id" do
    it "returns a success response" do
      question = create(:question)
      get question_path(question)
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /questions/:id/edit" do
    it "returns a success response" do
      question = create(:question)
      get edit_question_path(question)
      expect(response).to have_http_status(200)
    end
  end

  describe "PUT /questions/:id" do
    context "with valid params" do
      let(:new_attributes) {
        { title: "New title", text: "New text" }
      }

      it "updates the requested question" do
        question = create(:question)
        put question_path(question), params: { question: new_attributes }
        question.reload
        expect(question.title).to eq("New title")
        expect(question.text).to eq("New text")
      end

      it "redirects to the question" do
        question = create(:question)
        put question_path(question), params: { question: new_attributes }
        expect(response).to redirect_to(question)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        question = create(:question)
        put question_path(question), params: { question: { title: nil } }
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "DELETE /questions/:id" do
    it "destroys the requested question" do
      question = create(:question)
      expect {
        delete question_path(question)
      }.to change(Question, :count).by(-1)
    end

    it "redirects to the questions list" do
      question = create(:question)
      delete question_path(question)
      expect(response).to redirect_to(questions_path)
    end
  end
end
