package rude.ecs;

import haxe.ds.Either;

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