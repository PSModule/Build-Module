﻿$script:Planets = @(
    @{
        Name      = 'Mercury'
        Mass      = 0.330
        Diameter  = 4879
        DayLength = 4222.6
    },
    @{
        Name      = 'Venus'
        Mass      = 4.87
        Diameter  = 12104
        DayLength = 2802.0
    },
    @{
        Name      = 'Earth'
        Mass      = 5.97
        Diameter  = 12756
        DayLength = 24.0
    }
)

$script:Moons = @(
    @{
        Planet = 'Earth'
        Name   = 'Moon'
    }
)

$script:SolarSystems = @(
    @{
        Name    = 'Solar System'
        Planets = $script:Planets
        Moons   = $script:Moons
    },
    @{
        Name    = 'Alpha Centauri'
        Planets = @()
        Moons   = @()
    },
    @{
        Name    = 'Sirius'
        Planets = @()
        Moons   = @()
    }
)
