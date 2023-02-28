# frozen_string_literal: true

require "rails_helper"

RSpec.describe "V1::SpecialPeriod", type: :request do
  describe "POST /v1/day/:day_id/special_periods - v1/day/:day_id/special_periods#create" do
    let_it_be(:client_user)  { create(:user) }
    let_it_be(:auth_tokens)  { client_user.create_new_auth_token }
    let_it_be(:hotel) { create(:completed_profile_hotel, :with_days, user_id: client_user.id) }

    context "ログインしている場合" do
      it "ホテルの特別期間が投稿できること" do
        params = { special_period: { period: "obon", start_date: "20220808", end_date: "2022-08-15" }, day_id: hotel.days.ids[6] }
        expect do
          post v1_special_periods_path(hotel.days.ids[6]), params:, headers: auth_tokens
        end.to change(SpecialPeriod, :count).by(1)
        expect(response.status).to eq(200)
      end
    end

    context "ログアウトしている場合" do
      it "ホテルの特別期間が投稿できないこと" do
        params = { special_period: { period: "obon", start_date: "2022-08-08", end_date: "2022-08-15" }, day_id: hotel.days.ids[6] }
        post v1_special_periods_path(hotel.days.ids[6]), params:, headers: nil
        expect(response.status).to eq(401)
        expect(symbolized_body(response)[:errors][0]).to eq("ログイン、もしくはアカウント登録をしてください。")
      end
    end

    context "start_dateが無い場合" do
      it "ホテルの特別期間を投稿できないこと" do
        params = { special_period: { period: "obon", start_date: "", end_date: "2022-08-15" }, day_id: hotel.days.ids[6] }
        post v1_special_periods_path(hotel.days.ids[6]), params:, headers: auth_tokens
        expect(response.status).to eq(400)
        expect(symbolized_body(response)[:start_date][0]).to eq("開始日時を入力してください。")
      end
    end

    context "start_dateに西暦が無い場合" do
      it "ホテルの特別期間を投稿できないこと" do
        params = { special_period: { period: "obon", start_date: "08-15", end_date: "08-15" }, day_id: hotel.days.ids[6] }
        post v1_special_periods_path(hotel.days.ids[6]), params:, headers: auth_tokens
        expect(response.status).to eq(400)
        expect(symbolized_body(response)[:start_date][0]).to eq("開始日時を入力してください。")
      end
    end

    context "paramsがnilの場合" do
      it "ホテルの特別期間を投稿できないこと" do
        params = { special_period: { period: nil, start_date: nil, end_date: nil }, day_id: hotel.days.ids[6] }
        expect do
          post v1_special_periods_path(hotel.days.ids[6]), params:, headers: auth_tokens
        end.not_to change(SpecialPeriod, :count)
        expect(response.status).to eq(400)
        expect(symbolized_body(response)[:period][0]).to eq("特別期間が設定されていません")
      end
    end
  end

  describe "PATCH /v1/day/:day_id/special_periods/:id - v1/day/:day_id/special_periods/:id #update" do
    let_it_be(:client_user)  { create(:user) }
    let_it_be(:auth_tokens)  { client_user.create_new_auth_token }
    let_it_be(:hotel) { create(:completed_profile_hotel, :with_days_and_service_rates, user_id: client_user.id) }
    let_it_be(:day_id) { hotel.days.ids[6] }
    let_it_be(:special_period_id) { hotel.special_periods.ids[0] }

    context "ログインしているユーザーとホテル作成者が一致している場合" do
      it "ホテルの特別期間の開始日時を編集できること" do
        params = { special_period: { period: "obon", start_date: "2022-8-10", end_date: "2022-08-20" }, day_id: }
        patch v1_special_period_path(day_id, special_period_id), params:, headers: auth_tokens
        expect(response.status).to eq(200)
        expect(symbolized_body(response)[:specialPeriod][:startDate]).to eq("20220810")
      end
    end

    context "ホテル運営者以外が特別期間を編集しようとした場合" do
      let_it_be(:other_user) { create(:user) }
      let_it_be(:other_user_auth_tokens) { other_user.create_new_auth_token }

      it "400エラーを返すこと" do
        params = { special_period: { period: "obon", start_date: "2022-8-10", end_date: "2022-08-20" }, day_id: }
        patch v1_special_period_path(day_id, special_period_id), params:, headers: other_user_auth_tokens
        expect(response.status).to eq(400)
      end
    end

    # TODO: enumはRailsの仕様でvallidationよりも先にArgumenErrorをだしてしまう。enumがinvalidのときにどうするか。
    context "編集する時の特別な期間の値が不正な場合" do
      it "編集できないこと" do
        params = { special_period: { period: "obon", start_date: "8-10", end_date: "2022-08-20" }, day_id: }
        patch v1_special_period_path(day_id, special_period_id), params:, headers: auth_tokens
        expect(response.status).to eq(400)
        expect(symbolized_body(response)[:start_date][0]).to eq("開始日時を入力してください。")
      end
    end
  end

  describe "DELETE /v1/day/:day_id/special_periods/:id - v1/day/:day_id/special_periods/:id #destroy" do
    let_it_be(:client_user)  { create(:user) }
    let_it_be(:auth_tokens)  { client_user.create_new_auth_token }
    let_it_be(:hotel) { create(:completed_profile_hotel, :with_days_and_service_rates, user_id: client_user.id) }
    let_it_be(:day_id) { hotel.days.ids[6] }
    let_it_be(:special_period_id) { hotel.special_periods.ids[0] }

    context "ログインしているユーザーとホテル作成者が一致している場合" do
      it "ホテルの特別期間を削除できること" do
        expect do
          delete v1_special_period_path(day_id, special_period_id), headers: auth_tokens
        end.to change(SpecialPeriod, :count).by(-1)
        expect(response.status).to eq(200)
      end
    end

    context "ホテル運営者以外が特別期間を削除しようとした場合" do
      let_it_be(:other_user) { create(:user) }
      let_it_be(:other_user_auth_tokens) { other_user.create_new_auth_token }

      it "400エラーを返すこと" do
        delete v1_special_period_path(day_id, special_period_id), headers: other_user_auth_tokens
        expect(response.status).to eq(400)
      end
    end

    context "既に削除されている特別期間を削除しようとした場合" do
      before do
        delete v1_special_period_path(day_id, special_period_id), headers: auth_tokens
      end

      it "削除できないこと" do
        delete v1_special_period_path(day_id, special_period_id), headers: auth_tokens
        expect(response.status).to eq(404)
        expect(symbolized_body(response)[:errors][:body]).to eq("既に削除されてあるか、存在しないページです")
      end
    end
  end
end
