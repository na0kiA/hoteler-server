# frozen_string_literal: true

require "rails_helper"

RSpec.describe "V1::StayRates", type: :request do
  describe "POST /v1/day/:day_id/stay_rates - v1/day/:day_id/stay_rates#create" do
    let_it_be(:client_user)  { create(:user) }
    let_it_be(:auth_tokens)  { client_user.create_new_auth_token }
    let_it_be(:hotel) { create(:completed_profile_hotel, :with_days, user_id: client_user.id) }

    context "ログインしている場合" do
      it "ホテルの宿泊料金が投稿できること" do
        params = { stay_rate: { plan: "宿泊1部", rate: 5980, start_time: "20:00", end_time: "11:00" }, day_id: hotel.days.ids[0] }
        expect do
          post v1_stay_rates_path(hotel.days.ids[0]), params:, headers: auth_tokens
        end.to change(StayRate, :count).by(1)
        expect(response.status).to eq(200)
      end
    end

    context "ログアウトしている場合" do
      it "ホテルの宿泊料金が投稿できないこと" do
        params = { stay_rate: { plan: "宿泊1部", rate: 5980, start_time: "20:00", end_time: "11:00" }, day_id: hotel.days.ids[0] }
        post v1_stay_rates_path(hotel.days.ids[0]), params:, headers: nil
        expect(response.status).to eq(401)
        expect(symbolized_body(response)[:errors][0]).to eq("ログイン、もしくはアカウント登録をしてください。")
      end
    end

    context "planに記号が含まれる場合" do
      it "ホテルの宿泊料金が投稿できないこと" do
        params = { stay_rate: { plan: "<><><>", rate: 5980, start_time: "20:00", end_time: "11:00" }, day_id: hotel.days.ids[0] }
        post v1_stay_rates_path(hotel.days.ids[0]), params:, headers: auth_tokens
        expect(response.status).to eq(400)
        expect(symbolized_body(response)[:plan][0]).to eq("料金プランに無効な記号もしくはURLが含まれています")
      end
    end

    context "paramsがnilの場合" do
      it "ホテルの宿泊料金が投稿できないこと" do
        params = { stay_rate: { plan: nil, rate: nil, start_time: nil, end_time: nil }, day_id: hotel.days.ids[0] }
        expect do
          post v1_stay_rates_path(hotel.days.ids[0]), params:, headers: auth_tokens
        end.not_to change(StayRate, :count)
        expect(response.status).to eq(400)
        expect(symbolized_body(response)[:rate]).to eq(["価格を入力してください。", "価格は数値のみ入力できます。"])
      end
    end
  end

  describe "PATCH /v1/day/:day_id/stay_rates/:id - v1/day/:day_id/stay_rates/:id #update" do
    let_it_be(:client_user)  { create(:user) }
    let_it_be(:auth_tokens)  { client_user.create_new_auth_token }
    let_it_be(:hotel) { create(:completed_profile_hotel, :with_days_and_service_rates, user_id: client_user.id) }
    let_it_be(:day_id) { hotel.days.ids[0] }
    let_it_be(:stay_rate_id) { hotel.days[0].stay_rates.ids[0] }

    context "ログインしているユーザーとホテル作成者が一致している場合" do
      it "ホテルの宿泊料金を5000円に編集できること" do
        params = { stay_rate: { plan: "宿泊1部", rate: 5000, start_time: "20:00", end_time: "11:00" }, day_id: }
        patch v1_stay_rate_path(day_id, stay_rate_id), params:, headers: auth_tokens
        expect(response.status).to eq(200)
        expect(symbolized_body(response)[:rate]).to eq(5000)
      end
    end

    context "ホテル運営者以外が宿泊料金を編集しようとした場合" do
      let_it_be(:other_user) { create(:user) }
      let_it_be(:other_user_auth_tokens) { other_user.create_new_auth_token }

      it "400エラーを返すこと" do
        params = { stay_rate: { plan: "宿泊1部", rate: 5000, start_time: "20:00", end_time: "11:00" }, day_id: }
        patch v1_stay_rate_path(day_id, stay_rate_id), params:, headers: other_user_auth_tokens
        expect(response.status).to eq(400)
      end
    end

    context "編集する時の値が不正な場合" do
      it "編集できないこと" do
        params = { stay_rate: { plan: "<script>", rate: 1, start_time: "", end_time: "" }, day_id: }
        patch v1_stay_rate_path(day_id, stay_rate_id), params:, headers: auth_tokens
        expect(response.status).to eq(400)
        expect(symbolized_body(response)[:plan][0]).to eq("料金プランに無効な記号もしくはURLが含まれています")
      end
    end
  end

  describe "DELETE /v1/day/:day_id/stay_rates/:id - v1/day/:day_id/stay_rates/:id #destroy" do
    let_it_be(:client_user)  { create(:user) }
    let_it_be(:auth_tokens)  { client_user.create_new_auth_token }
    let_it_be(:hotel) { create(:completed_profile_hotel, :with_days_and_service_rates, user_id: client_user.id) }
    let_it_be(:day_id) { hotel.days.ids[0] }
    let_it_be(:stay_rate_id) { hotel.days[0].stay_rates.ids[0] }

    context "ログインしているユーザーとホテル作成者が一致している場合" do
      it "ホテルの宿泊料金を削除できること" do
        expect do
          delete v1_stay_rate_path(day_id, stay_rate_id), headers: auth_tokens
        end.to change(StayRate, :count).by(-1)
        expect(response.status).to eq(200)
      end
    end

    context "ホテル運営者以外が宿泊料金を削除しようとした場合" do
      let_it_be(:other_user) { create(:user) }
      let_it_be(:other_user_auth_tokens) { other_user.create_new_auth_token }

      it "400エラーを返すこと" do
        delete v1_stay_rate_path(day_id, stay_rate_id), headers: other_user_auth_tokens
        expect(response.status).to eq(400)
      end
    end

    context "既に削除されている宿泊料金を削除しようとした場合" do
      before do
        delete v1_stay_rate_path(day_id, stay_rate_id), headers: auth_tokens
      end

      it "削除できないこと" do
        delete v1_stay_rate_path(day_id, stay_rate_id), headers: auth_tokens
        expect(response.status).to eq(404)
        expect(symbolized_body(response)[:errors][:body]).to eq("既に削除されてあるか、存在しないページです")
      end
    end
  end
end
