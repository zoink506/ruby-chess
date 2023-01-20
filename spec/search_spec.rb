require 'spec_helper'
require 'yaml'
require_relative '../lib/Board.rb'
require_relative '../lib/Move.rb'

describe Piece do
  describe "#search" do 
    describe "Up" do
      let(:board) { Board.new }

      it "returns [...] for piece at c2" do
        piece = board.board[6][2]
        output = piece.search(board.board, 0, -1)
        expect(output).to eq([[5,2], [4,2], [3,2], [2,2], [1,2]])
      end

      it "returns [...] for piece at c7" do
        board.move_piece('d7', 'c5')
        piece = board.board[6][2]
        output = piece.search(board.board, 0, -1)
        expect(output).to eq([[5,2], [4,2], [3,2]])
      end

      it "returns [...] for piece at c8" do
        piece = board.board[0][2]
        output = piece.search(board.board, 0, -1)
        expect(output).to eq([])
      end

      it "returns [...] for piece at c6" do
        board.move_piece('c2', 'c6')
        piece = board.board[2][2]
        output = piece.search(board.board, 0, -1)
        expect(output).to eq([[1,2]])
      end
    end

    describe "Down" do
      let(:board) { Board.new }

      it "returns [...] for piece at c7" do
        piece = board.board[1][2]
        output = piece.search(board.board, 0, 1)
        expect(output).to eq([[2,2], [3,2], [4,2], [5,2], [6,2]])
      end

      it "returns [...] for piece at c4" do
        board.move_piece('c7', 'c4')
        piece = board.board[4][2]
        output = piece.search(board.board, 0, 1)
        expect(output).to eq([[5,2], [6,2]])
      end

      it "returns [...] for piece at c3" do
        board.move_piece('c7', 'c3')
        piece = board.board[5][2]
        output = piece.search(board.board, 0, 1)
        expect(output).to eq([[6,2]])
      end

      it "returns [...] for piece at a8" do
        piece = board.board[0][0]
        output = piece.search(board.board, 0, 1)
        expect(output).to eq([])
      end
    end

    describe "Left" do
      let(:board) { Board.new }

      it "returns [...] for piece at h3" do
        board.move_piece('h2', 'h3')
        piece = board.board[5][7]
        output = piece.search(board.board, -1, 0)
        expect(output).to eq([[5,6], [5,5], [5,4], [5,3], [5,2], [5,1], [5,0]])
      end

      it "returns [...] for piece at a3" do
        board.move_piece('a2', 'a3')
        piece = board.board[5][0]
        output = piece.search(board.board, -1, 0)
        expect(output).to eq([])
      end
    end

    describe "Right" do
      let(:board) { Board.new }

      it "returns [...] for piece at a3" do
        board.move_piece('a2', 'a3')
        piece = board.board[5][0]
        output = piece.search(board.board, 1, 0)
        expect(output).to eq([[5,1], [5,2], [5,3], [5,4], [5,5], [5,6], [5,7]])
      end

      it "returns [...] for piece at h3" do
        board.move_piece('h2', 'h3')
        piece = board.board[5][7]
        output = piece.search(board.board, 1, 0)
        expect(output).to eq([])
      end
    end

    describe "Diagonal" do
      describe "top-left" do
        let(:board) { Board.new }

        it "returns [...] for diagonal at d4" do
          board.move_piece('d2', 'd4')
          piece = board.board[4][3]
          output = piece.search(board.board, -1, -1)
          expect(output).to eq([[3,2], [2,1], [1,0]])
        end

        it "returns [...] for diagonal at a6" do
          board.move_piece('a2', 'a6')
          piece = board.board[2][0]
          output = piece.search(board.board, -1, -1)
          expect(output).to eq([])
        end
      end

      describe "top-right" do
        let(:board) { Board.new }

        it "returns [...] for diagonal at d4" do
          board.move_piece('d2', 'd4')
          piece = board.board[4][3]
          output = piece.search(board.board, 1, -1)
          expect(output).to eq([[3,4], [2,5], [1,6]])
        end
      end

      describe "bottom-left" do
        let(:board) { Board.new }

        it "returns [...] for diagonal at d5" do
          board.move_piece('d2', 'd5')
          piece = board.board[3][3]
          output = piece.search(board.board, -1, 1)
          expect(output).to eq([[4,2], [5,1]])
        end
      end

      describe "bottom-right" do

      end
    end
  end
end
