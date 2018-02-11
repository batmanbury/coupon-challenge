require 'rails_helper'

RSpec.describe CouponTransferService do
  describe '#transfer!' do
    let!(:poster) { FactoryBot.create(:user) }
    let!(:coupon) { FactoryBot.create(:coupon, poster: poster) }

    context 'with a user with insufficient funds' do
      let(:requester) { FactoryBot.create(:user, balance: 0) }

      it 'raises :requester error InsufficientFunds' do
        service = described_class.new(coupon, requester)
        service.transfer!
        expect(service.errors).to include(:requester)
      end

      it 'does not create a new transfer record' do
        expect {
          service = described_class.new(coupon, requester)
          service.transfer!
        }.to_not change {
          Transfer.count
        }
      end
    end

    context 'with a user with a sufficient balance' do
      let(:requester) { FactoryBot.create(:user) }

      it 'deducts the coupon value from the requester\'s balance' do
        expect {
          service = described_class.new(coupon, requester)
          service.transfer!
        }.to change {
          requester.balance
        }.by(-coupon.value)
      end

      it 'credits the coupon value, minus the transfer fee, to the poster\'s balance' do
        credit_amount = coupon.value - (coupon.value * Transfer::TRANSACTION_FEE_PERCENT)
        expect {
          service = described_class.new(coupon, requester)
          service.transfer!
        }.to change {
          poster.balance
        }.by(credit_amount)
      end

      it 'creates a new transfer record' do
        expect {
          service = described_class.new(coupon, requester)
          service.transfer!
        }.to change {
          Transfer.count
        }.by(1)
      end
    end

    context 'when a user requests their own coupon' do
      let(:requester) { poster }

      it 'raises :poster error PosterRequesterConflict' do
        service = described_class.new(coupon, requester)
        service.transfer!
        expect(service.errors).to include(:poster)
      end

      it 'does not create a new transfer record' do
        expect {
          service = described_class.new(coupon, requester)
          service.transfer!
        }.to_not change {
          Transfer.count
        }
      end
    end
  end
end
