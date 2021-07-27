/**
    Demonstrates basic use the rude.ecs library.

    This example randomly builds a bunch of entities and outputs statistics about the collection to the terminal. Components are stored in ComMap instances, and these are then queried by the systems.
**/
class Example {
    public static function main() {
        //Create ComMaps for our position and rect area components
        var posMap = new rude.ecs.ComMap<PositionCom>();
        var rectAreaMap = new rude.ecs.ComMap<RectAreaCom>();

        //Construct a system that will build a bunch of random entities
        var buildSys = new BuildSys(posMap, rectAreaMap);
        
        //Make a bunch of random components for entities. Some will have positions and/or areas, and some will have neither.
        for (i in 0...1000) {
            buildSys.makeEntity(i);
        }

        //Construct a system to report stats about the entities
        var statsSys = new StatsSys(posMap, rectAreaMap);
        //Update the system stats data and trace it to the terminal. In a real application, this kind of operation could happen in an update loop, but for the purpose of this example we'll only run it once.
        statsSys.update();
        statsSys.traceStats();
    }
}

/**
    An example component representing a 2D position for an entity.
**/
typedef PositionCom = {
    x:Float,
    y:Float
};

/**
    An example component representing a 2D rectangular area for an entity.
**/
class RectAreaCom {
    public var w = 0.0;
    public var h = 0.0;

    public function new(w=0.0, h=0.0) {
        init(w, h);
    }

    public inline function init(w=0.0, h=0.0) {
        this.w = w;
        this.h = h;
    }
}

/**
    An example system that simply builds a whole bunch of entities from random values.
**/
class BuildSys {
    // A ComQuery wrapper for the position and area maps. Note that the ComQuery isn't strictly necessary for this system since we're just adding new components, but it still provides a nice interface to the maps.
    var comQuery:rude.ecs.ComQuery2<PositionCom, RectAreaCom>;

    // Constructor accepts ComMaps for the components we're interested in, which is then built into a ComQuery instance.
    public function new(posMap:rude.ecs.ComMap<PositionCom>, rectAreaMap:rude.ecs.ComMap<RectAreaCom>) {
        this.comQuery = new rude.ecs.ComQuery2(posMap, rectAreaMap);
    }

    // Builds randomized components for a single EntityId.
    public function makeEntity(id:rude.ecs.EntityId) {
        if (Math.random() > 0.5) {
            comQuery.map0[id] = {x: Math.random()*100, y: Math.random()*100};
        }
        if (Math.random() > 0.5) {
            comQuery.map1[id] = new RectAreaCom(Math.random()*100, 
                Math.random()*100);
        }
    }
}

/**
    An example system that outputs various stats about the entities to the terminal.
    
    This system uses three ComQueries - one for only position components, one for only rect area components, and one for both. We can use multiple ComQuery instances with the same ComMaps without issues.

    This system provides answers to the following questions:
      1. How many entities exist with position components, rect area components, and both?
      2. Which entities have the highest and lowest values for their X/Y positions?
      3. Which entities have the highest and lowest widths and heights?
**/
class StatsSys {
    var posQuery:rude.ecs.ComQuery1<PositionCom>;
    var rectAreaQuery:rude.ecs.ComQuery1<RectAreaCom>;
    var bothQuery:rude.ecs.ComQuery2<PositionCom, RectAreaCom>;

    var posCount = 0;
    var rectCount = 0;
    var bothCount = 0;
    var posXMin = Math.POSITIVE_INFINITY;
    var posYMin = Math.POSITIVE_INFINITY;
    var rectWMin = Math.POSITIVE_INFINITY;
    var rectHMin = Math.POSITIVE_INFINITY;
    var posXMax = Math.NEGATIVE_INFINITY;
    var posYMax = Math.NEGATIVE_INFINITY;
    var rectWMax = Math.NEGATIVE_INFINITY;
    var rectHMax = Math.NEGATIVE_INFINITY;
    var posXMinId:rude.ecs.EntityId;
    var posXMaxId:rude.ecs.EntityId;
    var posYMinId:rude.ecs.EntityId;
    var posYMaxId:rude.ecs.EntityId;
    var rectWMinId:rude.ecs.EntityId;
    var rectWMaxId:rude.ecs.EntityId;
    var rectHMinId:rude.ecs.EntityId;
    var rectHMaxId:rude.ecs.EntityId;

    public function new(posMap:rude.ecs.ComMap<PositionCom>, rectAreaMap:rude.ecs.ComMap<RectAreaCom>) {
        posQuery = new rude.ecs.ComQuery1(posMap);
        rectAreaQuery = new rude.ecs.ComQuery1(rectAreaMap);
        bothQuery = new rude.ecs.ComQuery2(posMap, rectAreaMap);
        resetStats();
    }

    inline function resetStats() {
        posCount = 0;
        rectCount = 0;
        bothCount = 0;
        posXMin = Math.POSITIVE_INFINITY;
        posYMin = Math.POSITIVE_INFINITY;
        rectWMin = Math.POSITIVE_INFINITY;
        rectHMin = Math.POSITIVE_INFINITY;
        posXMax = Math.NEGATIVE_INFINITY;
        posYMax = Math.NEGATIVE_INFINITY;
        rectWMax = Math.NEGATIVE_INFINITY;
        rectHMax = Math.NEGATIVE_INFINITY;
        posXMinId = null;
        posXMaxId = null;
        posYMinId = null;
        posYMaxId = null;
        rectWMinId = null;
        rectWMaxId = null;
        rectHMinId = null;
        rectHMaxId = null;
    }

    /**
        Updates the stats values using the ComQueries.
    **/
    public function update() {
        resetStats();
        //Update position stats. We do this by first running the posQuery, then iterating over the results array to get each entity ID.
        posQuery.run();
        for (id in posQuery.result) {
            posCount++;
            var com = posQuery.map0[id];
            if (com.x < posXMin) {
                posXMin = com.x;
                posXMinId = id;
            }
            if (com.x > posXMax) {
                posXMax = com.x;
                posXMaxId = id;
            }
            if (com.y < posYMin) {
                posYMin = com.y;
                posYMinId = id;
            }
            if (com.y > posYMax) {
                posYMax = com.y;
                posYMaxId = id;
            }
        }

        //Similarly, update the rect area stats.
        rectAreaQuery.run();
        for (id in rectAreaQuery.result) {
            rectCount++;
            var com = rectAreaQuery.map0[id];
            if (com.w < rectWMin) {
                rectWMin = com.w;
                rectWMinId = id;
            }
            if (com.w > rectWMax) {
                rectWMax = com.w;
                rectWMaxId = id;
            }
            if (com.h < rectHMin) {
                rectHMin = com.h;
                rectHMinId = id;
            }
            if (com.h > rectHMax) {
                rectHMax = com.h;
                rectHMaxId = id;
            }
        }

        //Update stats pertaining to entities with both component types.
        bothQuery.run();
        bothCount = 0;
        for (id in bothQuery.result) {
            bothCount++;
        }
    }

    /**
        Trace the stats data out to the terminal.
    **/
    public function traceStats() {
        trace("=====rude.ecs Example=====");
        trace('Total entities with position: ${posCount}');
        trace('Total entities with rect area: ${rectCount}');
        trace('Total entities with both: ${bothCount}');
        if (posXMinId != null)
            trace('Entity with lowest X position: ${posXMinId} (${posXMin})');
        if (posXMaxId != null)
            trace('Entity with highest X position: ${posXMaxId} (${posXMax})');
        if (posYMinId != null)
            trace('Entity with lowest Y position: ${posYMinId} (${posYMin})');
        if (posYMaxId != null)
            trace('Entity with highest Y position: ${posYMaxId} (${posYMax})');
        if (rectWMinId != null)
            trace('Entity with lowest width: ${rectWMinId} (${rectWMin})');
        if (rectWMaxId != null)
            trace('Entity with highest width: ${rectWMaxId} (${rectWMax})');
        if (rectHMinId != null)
            trace('Entity with lowest height: ${rectHMinId} (${rectHMin})');
        if (rectHMaxId != null)
            trace('Entity with highest height: ${rectHMaxId} (${rectHMax})');
    }
}