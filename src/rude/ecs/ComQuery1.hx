package rude.ecs;

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