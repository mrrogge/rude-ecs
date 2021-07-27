package rude.ecs;

import haxe.ds.Either;

/**
    An identifier for an entity. Can be either a `String` or an `Int`.
**/
abstract EntityId(Either<String, Int>) from Either<String, Int> to Either<String, Int> {
    @:from
    inline public static function fromString(id:String):EntityId {
        return Left(id);
    }

    @:from
    inline public static function fromInt(id:Int):EntityId {
        return Right(id);
    }

    @:to
    inline public function toString():String {
        switch (this) {
            case Left(strId): return strId;
            case Right(intId): return Std.string(intId);
        }
    }

    @:to
    inline public function toInt():Null<Int> {
        switch (this) {
            case Left(strId): return null;
            case Right(intId): return intId;
        }
    }
}