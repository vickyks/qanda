# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Answers', type: :request do
  let(:question) { create(:question) }
  let(:valid_attributes) { attributes_for(:answer, question: question) }
  let(:invalid_attributes) { attributes_for(:answer, text: nil, question: question) }

  describe 'GET /questions/:question_id/answers' do
    it 'returns a success response' do
      create_list(:answer, 5, question: question)
      get question_answers_path(question)
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /questions/:question_id/answers/new' do
    it 'returns a success response' do
      get new_question_answer_path(question)
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /questions/:question_id/answers' do
    context 'with valid params' do
      it 'creates a new Answer' do
        expect do
          post question_answers_path(question), params: { answer: valid_attributes }
        end.to change(Answer, :count).by(1)
      end

      it 'redirects to the created answer' do
        post question_answers_path(question), params: { answer: valid_attributes }
        expect(response).to redirect_to([question, Answer.last])
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'new' template)" do
        post question_answers_path(question), params: { answer: invalid_attributes }
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'GET /questions/:question_id/answers/:id' do
    it 'returns a success response' do
      answer = create(:answer, question: question)
      get question_answer_path(question, answer)
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /questions/:question_id/answers/:id/edit' do
    it 'returns a success response' do
      answer = create(:answer, question: question)
      get edit_question_answer_path(question, answer)
      expect(response).to have_http_status(200)
    end
  end

  describe 'PUT /questions/:question_id/answers/:id' do
    context 'with valid params' do
      let(:new_attributes) do
        { text: 'New answer text' }
      end

      it 'updates the requested answer' do
        answer = create(:answer, question: question)
        put question_answer_path(question, answer), params: { answer: new_attributes }
        answer.reload
        expect(answer.text).to eq('New answer text')
      end

      it 'redirects to the answer' do
        answer = create(:answer, question: question)
        put question_answer_path(question, answer), params: { answer: new_attributes }
        expect(response).to redirect_to([question, answer])
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'edit' template)" do
        answer = create(:answer, question: question)
        put question_answer_path(question, answer), params: { answer: invalid_attributes }
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'DELETE /questions/:question_id/answers/:id' do
    it 'deletes the specified answer' do
      question = create(:question)
      answer = create(:answer, question: question)
      delete "/questions/#{question.id}/answers/#{answer.id}"
      expect(response).to have_http_status(:no_content)
      expect { answer.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'returns a 404 error if the answer does not belong to the specified question' do
      question = create(:question)
      answer = create(:answer)
      delete "/questions/#{question.id}/answers/#{answer.id}"
      expect(response).to have_http_status(:not_found)
    end

    it 'returns a 401 error if the user is not the owner of the answer' do
      question = create(:question)
      answer = create(:answer, question: question)
      other_user = create(:user)
      sign_in(other_user)
      delete "/questions/#{question.id}/answers/#{answer.id}"
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
