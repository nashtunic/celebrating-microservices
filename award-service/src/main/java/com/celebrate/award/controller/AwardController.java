package com.celebrate.award.controller;

import com.celebrate.award.dto.AwardDTO;
import com.celebrate.award.service.AwardService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/v1/awards")
public class AwardController {
    private final AwardService awardService;

    public AwardController(AwardService awardService) {
        this.awardService = awardService;
    }

    @GetMapping
    public ResponseEntity<List<AwardDTO>> getAllAwards() {
        return ResponseEntity.ok(awardService.getAllAwards());
    }

    @GetMapping("/{id}")
    public ResponseEntity<AwardDTO> getAwardById(@PathVariable Long id) {
        return ResponseEntity.ok(awardService.getAwardById(id));
    }

    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<AwardDTO> createAward(@Valid @RequestBody AwardDTO awardDTO) {
        return new ResponseEntity<>(awardService.createAward(awardDTO), HttpStatus.CREATED);
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<AwardDTO> updateAward(@PathVariable Long id, @Valid @RequestBody AwardDTO awardDTO) {
        return ResponseEntity.ok(awardService.updateAward(id, awardDTO));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Void> deleteAward(@PathVariable Long id) {
        awardService.deleteAward(id);
        return ResponseEntity.noContent().build();
    }
} 