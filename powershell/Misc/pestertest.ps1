describe 'MVA Pass' {
    it 'True is True' {
        $True | should be $True
    }
}

describe 'MVA Fail' {
    it 'True is not False' {
        $true | should be $false
    }
}

Describe 'MVA tests' {
    Context 'Arithmetic' {
        it '1plus1' {
                1 + 1 | Should be 2
            }

            it '3minus2' {
                3-2 | Should be 1
            }
    }
    Context 'String Matching' {
        it 'no i in team - like' {
            'team' | should not belike '*i*'
        }
        
        it 'no i in team -match' {
            'team' | should not match 'i'
        }
    }
    
}