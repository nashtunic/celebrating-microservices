package com.celebrate.award.service;

import com.celebrate.award.dto.AwardDTO;
import com.celebrate.award.model.Award;
import com.celebrate.award.repository.AwardRepository;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class AwardService {
    private final AwardRepository awardRepository;

    public AwardService(AwardRepository awardRepository) {
        this.awardRepository = awardRepository;
    }

    @Transactional(readOnly = true)
    public List<AwardDTO> getAllAwards() {
        return awardRepository.findAll().stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public AwardDTO getAwardById(Long id) {
        Award award = awardRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Award not found with id: " + id));
        return convertToDTO(award);
    }

    @Transactional
    public AwardDTO createAward(AwardDTO awardDTO) {
        if (awardRepository.existsByName(awardDTO.getName())) {
            throw new IllegalArgumentException("Award with this name already exists");
        }
        Award award = convertToEntity(awardDTO);
        award = awardRepository.save(award);
        return convertToDTO(award);
    }

    @Transactional
    public AwardDTO updateAward(Long id, AwardDTO awardDTO) {
        Award existingAward = awardRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Award not found with id: " + id));
        
        if (!existingAward.getName().equals(awardDTO.getName()) && 
            awardRepository.existsByName(awardDTO.getName())) {
            throw new IllegalArgumentException("Award with this name already exists");
        }

        BeanUtils.copyProperties(awardDTO, existingAward, "id", "createdAt", "updatedAt");
        existingAward = awardRepository.save(existingAward);
        return convertToDTO(existingAward);
    }

    @Transactional
    public void deleteAward(Long id) {
        if (!awardRepository.existsById(id)) {
            throw new EntityNotFoundException("Award not found with id: " + id);
        }
        awardRepository.deleteById(id);
    }

    private AwardDTO convertToDTO(Award award) {
        AwardDTO dto = new AwardDTO();
        BeanUtils.copyProperties(award, dto);
        return dto;
    }

    private Award convertToEntity(AwardDTO dto) {
        Award award = new Award();
        BeanUtils.copyProperties(dto, award, "id");
        return award;
    }
} 