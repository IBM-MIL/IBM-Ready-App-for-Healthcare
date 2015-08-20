describe("graphMapFactory", function() {

    /*
     *  Setup
     */
    
    // Mock ReadyAppHC
    beforeEach(module('ReadyAppHC'));

    // Retrieve providers
    var mapper;
    
    // Create milCtrl
    beforeEach(inject(function(_graphMapFactory_) {
        var graphMapper = _graphMapFactory_;
        mapper = new graphMapper();
    }));
    
    /*
     *  Specs
     */
    
    it("should be able to map data values properly", function() {
        mapper.setParams(-50, 50, [{x: "1", y: 10}, {x: "2", y: -10}, {x: "3", y: 7}, {x: "4", y: -7}, {x: "5", y: 1}], 48);
        
        expect(mapper.mapRange(0)).toBe(7);
        expect(mapper.mapRange(-50)).toBe(1);
        expect(mapper.mapRange(50)).toBe(10);
        expect(mapper.mapRange(51)).toBe(undefined);
        expect(mapper.mapRange(-51)).toBe(undefined);
        expect(mapper.mapRange(30)).toBe(10);
        expect(mapper.mapRange(29)).toBe(-10);
        expect(mapper.mapRange(-31)).toBe(1);
        expect(mapper.mapRange(-30)).toBe(-7);
    });
    
    it("should be able to map times properly", function() {
        mapper.setParams(-50, 50, [{x: "1", y: 10}, {x: "2", y: -10}, {x: "3", y: 7}, {x: "4", y: -7}, {x: "5", y: 1}], 48);
        
        expect(mapper.mapTime(0)).toBe(moment().subtract(2, 'hours').format('MMM Do, h:mm a'));
        expect(mapper.mapTime(-50)).toBe(moment().format('MMM Do, h:mm a'));
        expect(mapper.mapTime(50)).toBe(moment().subtract(4, 'hours').format('MMM Do, h:mm a'));
        expect(mapper.mapTime(51)).toBe(undefined);
        expect(mapper.mapTime(-51)).toBe(undefined);
        expect(mapper.mapTime(30)).toBe(moment().subtract(4, 'hours').format('MMM Do, h:mm a'));
        expect(mapper.mapTime(29)).toBe(moment().subtract(3, 'hours').format('MMM Do, h:mm a'));
        expect(mapper.mapTime(-30)).toBe(moment().subtract(1, 'hours').format('MMM Do, h:mm a'));
        expect(mapper.mapTime(-31)).toBe(moment().format('MMM Do, h:mm a'));
    });
    
    // Done Testing

});