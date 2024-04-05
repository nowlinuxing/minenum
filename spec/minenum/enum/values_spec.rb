# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Minenum::Enum::Values do
  describe '#key' do
    subject { values.key(actual) }

    context 'when the registerd values are Integer' do
      let(:values) { described_class.new(a: 1, 'b' => 2) }

      [
        %i[a a],
        ['a', :a],
        [1, :a],
        [:'1', nil],
        ['1', nil],
        %i[b b],
        ['b', :b],
        [2, :b],
        [:'2', nil],
        ['2', nil],
        [:not_registered, nil]
      ].each do |actual, expected|
        context "when called with #{actual.inspect}" do
          let(:actual) { actual }

          it { is_expected.to eq(expected) }
        end
      end
    end

    context 'when the registerd values are String' do
      let(:values) { described_class.new(a: 'foo', 'b' => 'bar') }

      [
        %i[a a],
        ['a', :a],
        %i[foo a],
        ['foo', :a],
        %i[b b],
        ['b', :b],
        %i[bar b],
        ['bar', :b],
        [:not_registered, nil]
      ].each do |actual, expected|
        context "when called with #{actual.inspect}" do
          let(:actual) { actual }

          it { is_expected.to eq(expected) }
        end
      end
    end

    context 'when the registerd values are Symbol' do
      let(:values) { described_class.new(a: :foo, 'b' => :bar) }

      [
        %i[a a],
        ['a', :a],
        %i[foo a],
        ['foo', :a],
        %i[b b],
        ['b', :b],
        %i[bar b],
        ['bar', :b],
        [:not_registered, nil]
      ].each do |actual, expected|
        context "when called with #{actual.inspect}" do
          let(:actual) { actual }

          it { is_expected.to eq(expected) }
        end
      end
    end
  end

  describe '#match?' do
    subject { values.match?(key_name, key_or_value) }

    context 'when the registerd values are Integer' do
      let(:values) { described_class.new(a: 1, 'b' => 2) }

      [
        [:a, :a, true],
        [:a, 'a', true],
        [:a, 1, true],
        [:a, :'1', false],
        [:a, '1', false],
        [:a, 'b', false],
        [:a, 2, false],
        [:a, :not_registered, false],
        ['a', :a, true],
        ['a', 'a', true],
        ['a', 1, true],
        ['a', :'1', false],
        ['a', '1', false],
        ['a', 'b', false],
        ['a', 2, false],
        ['a', :not_registered, false],
        [:b, :b, true],
        [:b, 'b', true],
        [:b, 2, true],
        [:b, :'2', false],
        [:b, '2', false],
        [:b, :a, false],
        [:b, 1, false],
        [:b, :not_registered, false],
        ['b', :b, true],
        ['b', 'b', true],
        ['b', 2, true],
        ['b', :'2', false],
        ['b', '2', false],
        ['b', :a, false],
        ['b', 1, false],
        ['b', :not_registered, false]
      ].each do |key_name, key_or_value, expected|
        context "when called with #{key_name.inspect}, #{key_or_value.inspect}" do
          let(:key_name) { key_name }
          let(:key_or_value) { key_or_value }

          it { is_expected.to eq(expected) }
        end
      end
    end

    context 'when the registerd values are String' do
      let(:values) { described_class.new(a: 'foo', 'b' => 'bar') }

      [
        [:a, :a, true],
        [:a, 'a', true],
        [:a, :foo, true],
        [:a, 'foo', true],
        [:a, 'b', false],
        [:a, 'bar', false],
        [:a, :not_registered, false],
        ['a', :a, true],
        ['a', 'a', true],
        ['a', :foo, true],
        ['a', 'foo', true],
        ['a', 'b', false],
        ['a', 'bar', false],
        ['a', :not_registered, false],
        [:b, :b, true],
        [:b, 'b', true],
        [:b, :bar, true],
        [:b, 'bar', true],
        [:b, :a, false],
        [:b, 'foo', false],
        [:b, :not_registered, false],
        ['b', :b, true],
        ['b', 'b', true],
        ['b', :bar, true],
        ['b', 'bar', true],
        ['b', :a, false],
        ['b', 'foo', false],
        ['b', :not_registered, false]
      ].each do |key_name, key_or_value, expected|
        context "when called with #{key_name.inspect}, #{key_or_value.inspect}" do
          let(:key_name) { key_name }
          let(:key_or_value) { key_or_value }

          it { is_expected.to eq(expected) }
        end
      end
    end

    context 'when the registerd values are Symbol' do
      let(:values) { described_class.new(a: :foo, 'b' => :bar) }

      [
        [:a, :a, true],
        [:a, 'a', true],
        [:a, :foo, true],
        [:a, 'foo', true],
        [:a, 'b', false],
        [:a, :bar, false],
        [:a, :not_registered, false],
        ['a', :a, true],
        ['a', 'a', true],
        ['a', :foo, true],
        ['a', 'foo', true],
        ['a', 'b', false],
        ['a', :bar, false],
        ['a', :not_registered, false],
        [:b, :b, true],
        [:b, 'b', true],
        [:b, :bar, true],
        [:b, 'bar', true],
        [:b, :a, false],
        [:b, :foo, false],
        [:b, :not_registered, false],
        ['b', :b, true],
        ['b', 'b', true],
        ['b', :bar, true],
        ['b', 'bar', true],
        ['b', :a, false],
        ['b', :foo, false],
        ['b', :not_registered, false]
      ].each do |key_name, key_or_value, expected|
        context "when called with #{key_name.inspect}, #{key_or_value.inspect}" do
          let(:key_name) { key_name }
          let(:key_or_value) { key_or_value }

          it { is_expected.to eq(expected) }
        end
      end
    end
  end
end
