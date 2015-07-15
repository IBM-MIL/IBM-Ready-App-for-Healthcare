describe("choreographerService", function() {

    /*
     *  Setup
     */
    
    // Mock ReadyAppHC
    beforeEach(module('ReadyAppHC'));

    // Retrieve providers
    var choreographerService;
    
    // Create milCtrl
    beforeEach(inject(function(_choreographerService_) {
        choreographerService = _choreographerService_;
    }));
    
    /*
     *  Specs
     */
    
    it("should have correct initial property values", function() {
        expect(choreographerService.delta).toBe(12);
        expect(choreographerService.tab).toBe(48);
        expect(choreographerService.graphWidth).toBe(0);
        expect(choreographerService.barWidth).toBe(6);
    });
    
    it("should adjust itself when notifed", function() {
        choreographerService.notify(8);
        
        expect(choreographerService.delta).toBe(90);
        expect(choreographerService.tab).toBe(8);
        
        choreographerService.notify(24);
        
        expect(choreographerService.delta).toBe(35);
        expect(choreographerService.tab).toBe(24);
        
        choreographerService.notify(48);
        
        expect(choreographerService.delta).toBe(12);
        expect(choreographerService.tab).toBe(48);
        
        choreographerService.notify(14);
        
        expect(choreographerService.delta).toBe(40);
        expect(choreographerService.tab).toBe(14);
    });
    
    // Done Testing

});