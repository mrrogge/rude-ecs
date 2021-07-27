package rude.ecs;

import haxe.ds.Either;

/**
    Underlying type for `ComMap`. Included here for completeness; there is no need to use this class directly.
**/
class ComMapInternal<T> {
    /**
        Holds component instances that are mapped to `Int` `EntityId`s.
    **/
    public var iMap(default, null) = new Map<Int, T>();
    /**
        Contains every `Int` key currently in `iMap`. Allows stateless iteration of those keys without needing to build a `keys()` iterator.
    **/
    public var iArray(default, null) = new Array<Null<Int>>();
    /**
        Holds component instances that are mapped to `String` `EntityId`s.
    **/
    public var sMap(default, null) = new Map<String, T>();
    /**
        Contains every `String` key currently in `sMap`. Allows stateless iteration of those keys without needing to build a `keys()` iterator.
    **/
    public var sArray(default, null) = new Array<String>();

    public function new() {}

    /**
        See `ComMap.get`.
    **/
    public function get(id:EntityId):Null<T> {
        switch (id) {
            case Left(strId): {
                return this.sMap[strId];
            }
            case Right(intId): {
                return this.iMap[intId];
            }
        }
    }

    /**
        See `ComMap.set`.
    **/
    public function set(id:EntityId, com:T):Void {
        switch (id) {
            case Left(strId): {
                if (com == null) {
                    if (this.sMap[strId] != null) {
                        this.sArray.remove(strId);
                    }
                    else {/* already removed */}
                }
                else {
                    if (this.sMap[strId] == null) {
                        this.sArray.push(strId);
                    }
                    else { /* already added */}
                }
                this.sMap[strId] = com;
            }
            case Right(intId): {
                if (com == null) {
                    if (this.iMap[intId] != null) {
                        this.iArray.remove(intId);
                    }
                    else {/* already removed */}
                }
                else {
                    if (this.iMap[intId] == null) {
                        this.iArray.push(intId);
                    }
                    else { /* already added */}
                }
                this.iMap[intId] = com;
            }
        }
    }

    /**
        Removes a component instance for a given `id`.
        @param id The `EntityId` key.
    **/
    inline public function remove(id:EntityId):Void {
        return this.set(id, null);
    }

    /**
        Returns `true` if a component instance exists for `id`, otherwise `false`.
        @param id The `EntityId` key.
    **/
    public function exists(id:EntityId):Bool {
        switch (id) {
            case Left(strId): {
                return this.sMap[strId] != null;
            }
            case Right(intId): {
                return this.iMap[intId] != null;
            }
        }
    }
}

/**
    A map of `EntityId`s to component instances. Components can be any type (specified by the `T` parameter).
**/
@:forward
@:forward.new
abstract ComMap<T>(ComMapInternal<T>) from ComMapInternal<T> to ComMapInternal<T> {
    /**
        Returns the component instance for a given `id`.
        @param id The `EntityId` key.
    **/
    @:arrayAccess
    public inline function get(id:EntityId) {
        return this.get(id);
    }

    /**
        Sets a component instance `com` for a given `id`.
        @param id The `EntityId key.
        @param com The component instance.
    **/
    @:arrayAccess
    public inline function set(id:EntityId, com:T) {
        return this.set(id, com);
    }
}