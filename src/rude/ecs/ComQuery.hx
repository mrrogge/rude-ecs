package rude.ecs;

import haxe.ds.Either;

/**
    Interface for component queries. These are used to find all the `EntityId`s that currently have a set of specific components.

    Implementations of `IComQuery` will typically accept `ComMap` instances in their constructors. They then populate an array with all the `EntityId`s that exist for all of those `ComMap` instances. This array is reused, so re-running the query in an update loop will not create junk instances each frame.
**/
interface IComQuery {
    /**
        After calling run(), this will contain every `EntityId` that is found for all `ComMap`s. The order of elements is undefined.
    **/
    public var result(default, null):Array<EntityId>;

    /**
        Updates the `result` array.
    **/
    public function run():Array<EntityId>;

    /**
        Returns true if the `id` has instances of all components defined for this query (otherwise false).
    **/
    public function hasAll(id:EntityId):Bool;
}

/**
    An implementation of `IComQuery` for a single `ComMap`.
**/
class ComQuery1<T0> implements IComQuery {

    public var map0(default, null):ComMap<T0>;

    @:inheritDoc(IComQuery.result)
    public var result(default, null) = new Array<EntityId>();

    public function new(map0:ComMap<T0>) {
        this.map0 = map0;
    }

    @:inheritDoc(IComQuery.run)
    public function run():Array<EntityId> {
        while (result.length > 0) result.pop();

        var idx = 0;
        while (this.map0.sArray[idx] != null) {
            var id = this.map0.sArray[idx];
            result.push(id);
            idx++;
        }

        idx = 0;
        while (this.map0.iArray[idx] != null) {
            var id = this.map0.iArray[idx];
            result.push(id);
            idx++;
        }

        return this.result;
    }

    @:inheritDoc(IComQuery.hasAll)
    public function hasAll(id:EntityId):Bool {
        return this.map0.exists(id);
    }
}

/**
    An implementation of `IComQuery` for two `ComMap`s.
**/
class ComQuery2<T0, T1> implements IComQuery {
    public var map0(default, null):ComMap<T0>;
    public var map1(default, null):ComMap<T1>;

    @:inheritDoc(IComQuery.result)
    public var result(default, null) = new Array<EntityId>();

    public function new(map0:ComMap<T0>, map1:ComMap<T1>) {
        this.map0 = map0;
        this.map1 = map1;
    }

    @:inheritDoc(IComQuery.run)
    public function run():Array<EntityId> {
        while (result.length > 0) result.pop();

        var idx = 0;
        while (this.map0.sArray[idx] != null) {
            var id = this.map0.sArray[idx];
            if (this.map1.exists(id)) {
                result.push(id);
            }
            idx++;
        }

        idx = 0;
        while (this.map0.iArray[idx] != null) {
            var id = this.map0.iArray[idx];
            if (this.map1.exists(id)) {
                result.push(id);
            }
            idx++;
        }

        return this.result;
    }

    @:inheritDoc(IComQuery.hasAll)
    public function hasAll(id:EntityId):Bool {
        switch (id) {
            case Left(strId):
                return this.map0.sMap[strId] != null && this.map1.sMap[strId] != null;
            case Right(intId):
                return this.map0.iMap[intId] != null && this.map1.iMap[intId] != null;
        }
    }

    /**
        Returns a `Tuple2` of components for a given `id` corresponding to the query's `ComMap`s. One or more components may be null if they do not exist for `id`.

        If a `tuple` argument is passed, the components will be applied to that instance and returned. Otherwise, a new `Tuple2` instance will be constructed and returned.

        @param id The entity identifier to check.

        @param tuple An existing tuple to reuse, if desired.
    **/
    public function getComTuple(id:EntityId, ?tuple:Tuple2<T0, T1>):Tuple2<T0, T1> {
        var returnedTuple = {
            if (tuple != null) tuple
            else new Tuple2();
        };
        switch (id) {
            case Left(strId):
                returnedTuple.e0 = this.map0.sMap[strId];
                returnedTuple.e1 = this.map1.sMap[strId];
            case Right(intId):
                returnedTuple.e0 = this.map0.iMap[intId];
                returnedTuple.e1 = this.map1.iMap[intId];
        }
        return returnedTuple;
    }
}

class ComQuery3<T0, T1, T2> implements IComQuery {
    public var map0(default, null):ComMap<T0>;
    public var map1(default, null):ComMap<T1>;
    public var map2(default, null):ComMap<T2>;
    public var result(default, null) = new Array<EntityId>();

    public function new(map0:ComMap<T0>, map1:ComMap<T1>, map2:ComMap<T2>) {
        this.map0 = map0;
        this.map1 = map1;
        this.map2 = map2;
    }

    public function run() {
        while (result.length > 0) result.pop();

        var idx = 0;
        while (this.map0.sArray[idx] != null) {
            var id = this.map0.sArray[idx];
            if (this.map1.exists(id) && this.map2.exists(id)) {
                result.push(id);
            }
            idx++;
        }

        idx = 0;
        while (this.map0.iArray[idx] != null) {
            var id = this.map0.iArray[idx];
            if (this.map1.exists(id) && this.map2.exists(id)) {
                result.push(id);
            }
            idx++;
        }

        return this.result;
    }

    public function hasAll(id:EntityId):Bool {
        switch (id) {
            case Left(strId):
                return this.map0.sMap[strId] != null && this.map1.sMap[strId] != null && this.map2.sMap[strId] != null;
            case Right(intId):
                return this.map0.iMap[intId] != null && this.map1.iMap[intId] != null && this.map2.iMap[intId] != null;
        }
    }

    //Returns a new Tuple of components for a given id using the query's ComMaps. One or more components may be null if the given id does not own that component type. If an optional tuple argument is supplied, the components will be applied to that existing tuple rather than constructing a new instance.
    public function getComTuple(id:EntityId, ?tuple:Tuple3<T0, T1, T2>):Tuple3<T0, T1, T2> {
        var returnedTuple = {
            if (tuple != null) tuple
            else new Tuple3();
        };
        switch (id) {
            case Left(strId):
                returnedTuple.e0 = this.map0.sMap[strId];
                returnedTuple.e1 = this.map1.sMap[strId];
                returnedTuple.e2 = this.map2.sMap[strId];
            case Right(intId):
                returnedTuple.e0 = this.map0.iMap[intId];
                returnedTuple.e1 = this.map1.iMap[intId];
                returnedTuple.e2 = this.map2.iMap[intId];
        }
        return returnedTuple;
    }
}